resource "aws_instance" "bastion-host" {
  ami           = "ami-064519b8c76274859" # Make sure this AMI is compatible with Rancher
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  tags = {
    Name = "${var.project_name}_${var.env}_bastion_host"
  }
}