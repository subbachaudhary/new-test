terraform {
  required_version = "~> 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket  = "riskflo-terraform-bucket"
    key     = "dev/terraform_test_statefile"
    region  = "us-east-1"
    profile = "risk"

  }
}