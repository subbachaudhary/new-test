terraform {
  required_version = "~> 1.5.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5.0"
    }
  }
  backend "s3" {
  }
}

#Providers

provider "aws" {
  # profile = var.profile
  region  = var.aws_region
}