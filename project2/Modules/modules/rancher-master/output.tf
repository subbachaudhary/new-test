output "ec2_public_ip" {
  value = aws_instance.rancher-master.public_ip
}
