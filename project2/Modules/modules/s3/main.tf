resource "aws_s3_bucket" "riskflo-terraform" {
  bucket = "riskflo-buckt"

  tags = {
    Name        = "env"
    Environment = "Test"
  }
}