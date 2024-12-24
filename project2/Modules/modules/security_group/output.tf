output "alb_sg" {
  value = aws_security_group.load_balancer_sg.id
}

output "eb_ec2_sg" {
  value = aws_security_group.ec2_sg.id

}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}
output "rancher_ec2_sg" {
  value = aws_security_group.rancher_ec2_sg.id
}