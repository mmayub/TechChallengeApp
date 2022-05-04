data "aws_caller_identity" "current" {}

data "aws_subnets" "available" {
  filter {
    name   = "tag:Name"
    values = ["*private-subnet*"]
  }
}