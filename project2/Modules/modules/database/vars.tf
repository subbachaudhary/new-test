variable "env" {}
variable "project_name" {}

variable "aws_db_subnet_group_id" {
  type        = string
  description = "ID of subnet group from VPC Module."
}

variable "rds_sg_id" {
  type        = string
  description = "Seecurity Group ID created for RDS."
}

variable "db_engine" {
  type        = string
  default     = "mysql"
  description = "Database engine MySQL/ Postgresql"
}

variable "db_engine_version" {
  type        = string
  default     = "8.0"
  description = "Database Engine Version"
}

variable "db_instance_class" {
  type        = string
  description = "Instance class of the RDS"
  default     = "db.t3.micro"

}

variable "db_password" {
  description = "defining the password of the database"
  type        = string
}
