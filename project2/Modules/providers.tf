provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  default_tags {
    tags = {
      project     = var.project_name
      environment = var.env
    }
  }
}

provider "aws" {
  alias   = "east"
  region  = "us-east-1"
  profile = "risk"

}