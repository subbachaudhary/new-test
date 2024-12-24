resource "aws_vpc" "default" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project_name}_${var.env}_vpc"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.project_name}_${var.env}_private_subnet_${count.index}"
  }
}

resource "aws_route" "private" {
  count = length(var.private_subnet_cidr_blocks)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default.id

}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id = aws_vpc.default.id
  tags = {
    Name = "private_rtb_${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id

}


resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}_${var.env}_public_subnet_${count.index}"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "${var.project_name}_${var.env}_public_rtb"
  }

}


resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.default.id
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = flatten([
    aws_route_table.public.id,
    aws_route_table.private.*.id
  ])
  tags = {
    Name = "${var.project_name}_${var.env}_vpc_endpoint"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

}

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "${var.project_name}_${var.env}_eip"
  }
}

resource "aws_nat_gateway" "default" {

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.default]
  tags = {
    Name = "${var.project_name}_${var.env}_nat"
  }

}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.project_name}-${var.env}-subnet-group"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  depends_on = [
    aws_subnet.private
  ]
}