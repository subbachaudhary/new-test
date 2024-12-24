variable "route53_zone_id" {
  type = string
}

variable "route53_name" {
  type = string
}

variable "shared_alb_dns_name" {
  type = string
}

variable "shared_alb_zone_id" {
  type = string
}

variable "api_domain" {
  type        = string
  description = "This is the  domains or sub domains we will use to configure for the AWS record for API."
}