# Internal Backend ALB 
resource "aws_security_group" "backend_alb_sg" {

  name        = "${var.environment}-ALB-SecurityGroup"
  description = "Allow  ALB Ingress inbound traffic"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.backend_alb_sg
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      cidr_blocks = ingress.value
      protocol    = "tcp"
      description = "${ingress.key} port allow  ALB Ingress traffic"
    }
  }
  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Outbound rule"
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  tags = {
    Name = "${var.environment}_ALB_sg"
  }
}


# Nginx SecurityGroup
resource "aws_security_group" "backend_nginx_sg" {

  name        = "${var.environment}-Backend_nginx_sg"
  description = "Allow nginx app to nginx ecs inbound traffic"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.nginx_sg_ecs
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      cidr_blocks = ingress.value
      protocol    = "tcp"
      description = "${ingress.key} port allow nginx for Eventlogic VPC and VPN"
    }
  }
  ingress {
    security_groups = [aws_security_group.backend_alb_sg.id]
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
  }
  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Outbound rule"
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  tags = {
    Name = "${var.environment}-nginx-SG"
  }
}

# EFS SecurityGroups
resource "aws_security_group" "EFS_sg" {

  name        = "${var.environment}-EFS_sg"
  description = "Allow EFS ecs inbound traffic"
  vpc_id      = var.vpc_id
  ingress {
    security_groups = [
      aws_security_group.backend_nginx_sg.id,
      aws_security_group.Remote_sg.id,
    ]
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
  }

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Outbound rule"
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  tags = {
    Name = "${var.environment}-EFS-SG"
  }
}


# RemoteAccess SecurityGroups
resource "aws_security_group" "Remote_sg" {

  name        = "${var.environment}-Remote_sg"
  description = "Allow Remote ecs inbound traffic"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.remote_sg
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      cidr_blocks = ingress.value
      protocol    = "tcp"
      description = "${ingress.key} port allow ALB Ingress traffic"
    }
  }

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Outbound rule"
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  tags = {
    Name = "${var.environment}-RemoteAccess-SG"
  }
}
