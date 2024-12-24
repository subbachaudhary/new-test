resource "aws_instance" "rancher-master" {
  ami           = "ami-064519b8c76274859" # Make sure this AMI is compatible with Rancher
  instance_type = "t3.medium"
  subnet_id     = var.subnet_id
  key_name      = "risk-dev-key"
  tags = {
    Name = "${var.project_name}_${var.env}_rke_server"
  }

  # Use user_data to install Docker and Rancher
  user_data = <<-EOF
              #!/bin/bash
              # Update package index
              sudo yum update -y

              # Install Docker
              sudo amazon-linux-extras install docker -y
              sudo systemctl start docker
              sudo systemctl enable docker

              # Run Rancher container
              sudo docker run -d --restart=unless-stopped \
                -p 80:80 -p 443:443 \
                rancher/rancher:v2.6.8 # You can change the version as needed

              EOF
}
