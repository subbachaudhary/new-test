resource "aws_instance" "jenkins" {
  ami           = "ami-064519b8c76274859" # Make sure this AMI is compatible with Jenkins
  instance_type = "t3.medium"
  subnet_id     = var.subnet_id
  key_name      = "risk-dev-key"
  tags = {
    Name = "${var.project_name}_${var.env}_jenkins_server"
  }

  # Use user_data to install Jenkins
  user_data = <<-EOF
              #!/bin/bash
              # Update package index
              sudo yum update -y

              # Install Java (Jenkins requires Java)
              sudo yum install -y java-1.8.0-openjdk

              # Add the Jenkins repository
              sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

              # Install Jenkins
              sudo yum install -y jenkins

              # Start Jenkins service
              sudo systemctl start jenkins

              # Enable Jenkins to start on boot
              sudo systemctl enable jenkins
              EOF
}