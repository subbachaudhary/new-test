# Load Balancer Security Group.
#Rancher RKE SG
resource "aws_security_group" "rancher_ec2_sg" {
  name        = "${var.project_name}_${var.env}_shared_ec2_sg"
  description = "Allow Http/s Connection"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}_${var.env}_shared_ec2_sg"
  }
}

#################################################
resource "aws_security_group" "load_balancer_sg" {
  name        = "${var.project_name}_${var.env}_shared_lb_sg"
  description = "Allow Http/s Connection"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}_${var.env}_shared_lb_sg"
  }
}

resource "aws_security_group" "ec2_bastion_sg" {
  name        = "${var.project_name}_${var.env}_bastion_sg"
  description = "Bastion host security group"
  vpc_id      = var.vpc_id



  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "${var.project_name}_${var.env}_bastion_sg"
  }
}
#################################################


#EC2 Security Group
#################################################
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}_${var.env}_ec2_sg"
  description = "EC2 instance beanstalk security groups"
  vpc_id      = var.vpc_id


  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_bastion_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  depends_on = [
    aws_security_group.ec2_bastion_sg,
    aws_security_group.load_balancer_sg
  ]
  tags = {
    Name = "${var.project_name}_${var.env}_ec2_sg"
  }
}

# RDS Security Group
#################################################
resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}_${var.env}_rds_sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id
  ingress {
    from_port       = 0
    to_port         = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_groups = [aws_security_group.ec2_sg.id, aws_security_group.ec2_bastion_sg.id]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    security_groups = [aws_security_group.ec2_sg.id, aws_security_group.ec2_bastion_sg.id]
  }
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id, aws_security_group.ec2_bastion_sg.id]
  }
  depends_on = [
    aws_security_group.ec2_bastion_sg,
    aws_security_group.ec2_sg
  ]
  tags = {
    Name = "${var.project_name}_${var.env}_rds_sg"
  }
}
###################################################