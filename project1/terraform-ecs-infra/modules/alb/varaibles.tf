variable "security_groups_alb" {
    description = "List of security group IDs for the ALB"
    type        = list(string)
}
variable "public_subnets_alb" {
    description = "List of security group IDs for the ALB"
    type        = list(string)
}
variable "alb_name" {
      description = "alb_name"
      type        = string
}
variable "acm_arn" {}
variable "bucket_name" {
      description = "bucket_name"
      type        = string
}
variable "targetgroup_name" {
      description = "targetgroup_name"
      type        = string
}
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
variable "environment" {
  description = "environment VPC"
  type        = string
}
variable "target_type" {
  description = "target_type"
  type        = string
}