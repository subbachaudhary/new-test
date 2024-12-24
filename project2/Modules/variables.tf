variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "env" {
  type        = string
  description = "Environment for which the infrastructure is being created"
}
variable "project_name" {
  description = "The name of the project"
  type        = string
}
variable "region" {
  description = "Region of the resources to be created."
  type        = string
}
variable "key_name" {
  description = "defining key name for the ec2 instatance"
  type        = string
}
#Networking Related.
###########################################
variable "vpc_cidr" {
  type        = string
  description = "CIDR Range for our VPC"
}
variable "public_subnet_cidr_blocks" {
  description = "List of public subnet CIDR blocks"
  type        = list(any)
}

variable "private_subnet_cidr_blocks" {
  description = "List of private subnet CIDR blocks"
  type        = list(any)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(any)
}
# variable "subnet_id" {
#   description = "defining the public subnet id for the ec2 instance"
#   type        = string

# }
# route53 details
#######################################################
variable "domain_name" {
  description = "define domain name"
  type        = string
}
variable "zone_name" {
  description = "This is the route 53 hosted zone name"
  type        = string
}
variable "api_domain" {
  description = "This is the route 53 hosted zone name"
  type        = string
}
variable "hosted_zone_id" {
  description = "defining zone id of the dns"
  type        = string
}
variable "subject_alternative_names" {
  type        = list(string)
  description = "Alternative names for the domains."
}
# dns passwdz
#####################################################
variable "db_password" {
  description = "defining passwd of the database"
  type        = string
}
