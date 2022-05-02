data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}



# data "aws_availability_zones" "azs" {}

# data "aws_vpc" "selected" {
#   id = var.vpc_id
# }

