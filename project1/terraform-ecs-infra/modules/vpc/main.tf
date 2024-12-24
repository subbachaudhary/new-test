# VPC

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name = var.vpc_name
  }
}
#Internet Gateway

resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = var.igw_tag
  }
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.myIGW]
  tags       = {
      Name = "EIP_NAT1"
   }
}
# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)

  tags = {
    Name        = "${var.environment}-public-NAT-1"
    Environment = "${var.environment}"
  }
}

/* Public subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.environment}-public-subnet-${element(var.availability_zones, count.index)}"
    Environment = "${var.environment}"

  }
}
/* Private subnet */
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.environment}-private-subnet-${element(var.availability_zones, count.index)}"
    Environment = "${var.environment}"
  }
}

################################################################################
# Publiс routes
################################################################################

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.environment}-public-route-table"
  }
}
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myIGW.id
}


################################################################################
# private route table
################################################################################

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-private-route-table1"
  }
}

resource "aws_route_table" "private_route_table2" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-private-route-table2"
  }
}
# Route for NAT
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
resource "aws_route" "private_nat_gateway2" {
  route_table_id         = aws_route_table.private_route_table2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
# Route table association with public subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

# Route table association with private subnets
resource "aws_route_table_association" "private" {
  subnet_id      = element(aws_subnet.private_subnet.*.id, 0)
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private2" {
  subnet_id      = element(aws_subnet.private_subnet.*.id, 1)
  route_table_id = aws_route_table.private_route_table2.id
}