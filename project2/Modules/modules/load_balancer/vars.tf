variable "env" {}
variable "project_name" {}
variable "public_subnet_cidr_blocks" {
  type        = list(any)
  description = "List of public subnet to create the load balancer in different az"
}
variable "vpc_id" {
  description = "ID of the VPC in which security resources are deployed"
  type        = string
}

variable "alb_sg" {
  description = "ID of the Security Group of ALB"
  type        = string
}

variable "certificate_arn" {
  description = "Created certificate ARN"
  type        = string
}