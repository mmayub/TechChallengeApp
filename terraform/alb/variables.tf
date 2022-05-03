variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "subnets" {
  description = "Comma separated list of subnet IDs"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "alb_security_group" {
  description = "security group for ALB"
}

variable "app_port" {
  description = "The port where the app is exposed"
}

variable "health_check_path" {
  description = "Path to check if the service is healthy, e.g. \"/status\""
}