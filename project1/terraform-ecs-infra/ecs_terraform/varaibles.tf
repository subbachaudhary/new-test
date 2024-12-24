
#####  ECS Project #########

variable "project" {}
variable "createdBy" {}

variable "aws_region" {}
variable "profile" {}
variable "prod-profile" {}
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
variable "volume_size" {}
variable "instance_ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "pre_assign_privateip" {}

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
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
variable "target_type" {
  description = "target_type"
  type        = string
}

### ECS varaibles

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