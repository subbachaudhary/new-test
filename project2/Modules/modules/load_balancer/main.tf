resource "aws_lb" "riskflo-loadbalancer" {
  name               = "${var.project_name}-${var.env}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for public_subnet in var.public_subnet_cidr_blocks : public_subnet]
  security_groups    = [var.alb_sg]
  tags = {
    Name = "${var.project_name}_${var.env}_alb"
  }
}


resource "aws_lb_target_group" "shared_target_group" {
  name     = "${var.project_name}-${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "shared_target_group_https" {
  name     = "${var.project_name}-${var.env}-https-tg"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "shared_lb_listener_1" {
  load_balancer_arn = aws_lb.riskflo-loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}



resource "aws_lb_listener" "shared_alb_listener_https" {
  load_balancer_arn = aws_lb.riskflo-loadbalancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shared_target_group.arn
  }
}