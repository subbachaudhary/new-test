
variable "volume_size" {}
variable "instance_ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "pre_assign_privateip" {}
variable "public_subnet" {}
variable "environment" {
  description = "environment VPC"
  type        = string
}
variable "security_groups" {
  description = "List of security group IDs for the EC2 instance"
  type        = list(string)
}
variable "security_groups_efs" {
  description = "List of security group IDs for the EC2 instance"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}
variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
  default     = "./private-key/BastionAccessInstanceKey.pem"
}