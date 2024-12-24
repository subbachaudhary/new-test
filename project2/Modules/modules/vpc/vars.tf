variable "env" {
    description = "environment variables"
    type        = string
}
variable "project_name" {}
variable "vpc_cidr" {}
variable "public_subnet_cidr_blocks" {}
variable "private_subnet_cidr_blocks" {}
variable "availability_zones" {}
variable "region" {}