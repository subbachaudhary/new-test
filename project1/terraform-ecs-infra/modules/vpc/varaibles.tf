
##### VPC  ECS Project #########

variable "environment" {}

variable "cidr" {}
variable "igw_tag" {}
variable "vpc_name" {}


variable "enable_dns_support" {
    type        = bool
}

variable "enable_dns_hostnames" {
    type        = bool
}

variable "public_subnets_cidr" {
    type        = list(any)
}
variable "private_subnets_cidr" {
    type        = list(any)
}
variable "availability_zones" {
    type        = list(any)
}