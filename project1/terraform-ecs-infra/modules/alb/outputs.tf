output "alb_arn" {
  description = "ALB arn"
  value       = aws_lb.eventlogic_alb.arn
}

output "alb_target_group_arn" {
  description = "ALB target group arn"
  value       = aws_lb_target_group.lb-targetgroup.arn
}

