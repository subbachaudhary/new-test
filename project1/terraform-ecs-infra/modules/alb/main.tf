data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "elb_logs" {
  bucket        = "${var.environment}-${var.bucket_name}"
  force_destroy = true
}
# resource "aws_s3_bucket_acl" "elb_logs_acl" {
#   bucket = aws_s3_bucket.elb_logs.id
#   acl    = "private"
# }

resource "aws_s3_bucket_policy" "allow_elb_logging" {
  bucket = aws_s3_bucket.elb_logs.id
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.environment}-${var.bucket_name}/logs/AWSLogs/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}


# Application loadbalancer-----

resource "aws_lb" "eventlogic_alb" {
  name                       = "${var.environment}-${var.alb_name}"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.security_groups_alb
  subnets                    = var.public_subnets_alb
  idle_timeout               = "300"
  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.elb_logs.bucket
    prefix  = "logs"
    enabled = true
  }

  tags = {
    Environment = "${var.environment}-ALB"
  }
}

# 80 listener Redriect to 443

# resource "aws_lb_listener" "front_end_listner-HTTP" {
#   load_balancer_arn = aws_lb.eventlogic_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }


# }



# 443 listener 


# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.eventlogic_alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.acm_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.lb-targetgroup.arn
#   }
# }

# Client Testing ... only
resource "aws_lb_listener" "front_end_listner-HTTP" {
  load_balancer_arn = aws_lb.eventlogic_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-targetgroup.arn
  }
}
#ALB target group

resource "aws_lb_target_group" "lb-targetgroup" {
  name        = "${var.environment}-${var.targetgroup_name}"
  port        = 80
  protocol    = "HTTP"
  target_type = var.target_type
  vpc_id      = var.vpc_id
  health_check {
    path = "/"
    # port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 6
    matcher             = "200"
    interval            = 30
    timeout             = 5
  }
}
