output "vpc_id" {
  value = aws_vpc.default.id
}

output "public_subnet_list" {
  value = [for public_subnet in aws_subnet.public : public_subnet.id]
}

output "private_subnet_list" {
  value = [for private_subnet in aws_subnet.private : private_subnet.id]
}

output "rds_subnet_group_id" {
  value = aws_db_subnet_group.rds_subnet_group.id
}