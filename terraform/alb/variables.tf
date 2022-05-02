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

variable "security_groups" {
  description = "Comma separated list of security groups"
}

variable "container_port" {
  description = "The port where the Docker is exposed"
}

variable "health_check_path" {
  description = "Path to check if the service is healthy, e.g. \"/status\""
}