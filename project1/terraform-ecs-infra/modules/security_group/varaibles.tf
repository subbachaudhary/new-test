variable "backend_alb_sg" {
  description = "Allowed client app to  alb tg"
  type        = map(any)
}

variable "nginx_sg_ecs" {
  description = "Allowed remoteAccess to Instance and vpc"
  type        = map(any)
}

variable "remote_sg" {
  description = "Allowed remoteAccess to Instance and vpc"
  type        = map(any)
}
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
variable "environment" {
  description = "environment VPC"
  type        = string
}