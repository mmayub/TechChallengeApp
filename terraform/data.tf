data "aws_caller_identity" "current" {}

data "aws_subnets" "available" {
  filter {
    name   = "tag:Name"
    values = ["*private-subnet*"]
  }
}

data "aws_vpc" "selected" {
  tags = {
    Name = "${var.name}-vpc-${var.environment}"
  }
}

