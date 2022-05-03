variable "app_security_group" {
  description = "security group for the app"
}

variable "vpc_zone_identifier" {
  description = "security group for the app"
}

variable "aws_alb_target_group_arn" {
  description = "target group for the load balancer"
}

variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}


# variable "db_record" {
#   description = "private db record resource"
# }

# variable "rds" {
#   description = "db resource"
# }