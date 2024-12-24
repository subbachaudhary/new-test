output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

output "route53_zone_id" {
  value = data.aws_route53_zone.dns.zone_id

}

output "route53_name" {
  value = data.aws_route53_zone.dns.name
}