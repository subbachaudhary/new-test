variable "env" {}
variable "project_name" {}
variable "key_name" {
  description = "defining key name for the ec2 instatance"
  type        = string
}
variable "subnet_id" {
    description = "define subnet for the instance"
    type        = string
}
