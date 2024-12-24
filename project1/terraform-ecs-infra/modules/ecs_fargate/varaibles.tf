variable "alb_arn" {
  description = "ALB arn"
  type        = string
}
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
variable "environment" {
  description = "environment name"
  type        = string
}
variable "services-ecs" {
  description = "ECS services discovery"
  type        = string
}
variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}
variable "task_nginx" {}
variable "svc_name" {}
variable "nginx-config" {}
variable "nginx-html" {}
variable "aws_region" {}
variable "app_desired_count" {}
variable "capacity_provider1" {}
variable "capacity_provider2" {}
variable "container_name" {}
variable "container_port" {}
variable "target_value_memory" {}
variable "max_capacity" {}
variable "min_capacity" {}
variable "nginx-memory" {}
variable "nginx-cpu" {}
variable "target_value_cpu" {}
variable "efs_volumes" {
  description = "nginx volumes"
  type        = map 
}
variable "file_system_id" {
  description = "EFS id"
  type        = string
}
variable "target_group_ecs" {
  description = "TG arn"
  type        = string
}
variable "security_groups_ecs" {
    description = "List of security group IDs for the ECS services"
    type        = list(string)
}
variable "private_subnets_ecs" {
    description = "List of Private subnets IDs for the ECS services"
    type        = list(string)
}