
resource "aws_route53_record" "www_api" {
  zone_id = var.route53_zone_id
  name    = var.api_domain
  type    = "A"

  alias {
    name                   = var.shared_alb_dns_name
    zone_id                = var.shared_alb_zone_id
    evaluate_target_health = true
  }
}