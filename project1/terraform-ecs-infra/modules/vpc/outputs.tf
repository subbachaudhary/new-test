output "vpc_name" {
  description = "The name/id of the VPC."
  value       = aws_vpc.vpc.id
}
output "public_subnets" {
  description = "Public subnets of VPC"
  value       = aws_subnet.public_subnet[*].id
}
output "private_subnets" {
  description = "Private subnets of VPC"
  value       = aws_subnet.private_subnet[*].id
}
output "public_subnet" {
  description = "Public subnets of VPC"
  value       = aws_subnet.public_subnet[0].id
}