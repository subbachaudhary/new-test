output "shared_alb_arn" {
  value = aws_lb.riskflo-loadbalancer.arn
}

output "shared_alb_id" {
  value = aws_lb.riskflo-loadbalancer.arn
}
##############################################
# used in Route53
output "shared_alb_dns_name" {
  value = aws_lb.riskflo-loadbalancer.dns_name
}

output "shared_alb_zone_id" {
  value = aws_lb.riskflo-loadbalancer.zone_id
}