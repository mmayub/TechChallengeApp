variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "region" {
  description = "the AWS region in which resources are created"
}

variable "subnets" {
  description = "List of subnet IDs"
}

variable "ecs_service_security_groups" {
  description = "Comma separated list of security groups"
}

variable "container_port" {
  description = "Port of container"
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
}

# variable "container_image" {
#   description = "Docker image to be launched"
# }

variable "aws_alb_target_group_arn" {
  description = "ARN of the alb target group"
}

variable "aws_ecr_repository_url" {
  description = "URL to ECR where app image is stored"
}

variable "service_desired_count" {
  description = "Number of services running in parallel"
}

variable "container_environment" {
  description = "The container environmnent variables"
  type        = list
}

variable "rds_endpoint" {
  description = "endpoint of rds cluster"
}

variable "db_name" {
  description = "Name of the DB"
}
variable "db_username" {
  description = "username for db"
}
variable "db_password" {
  description = "password for db"
}

variable "db_listen_host" {
  description = "host listening address"
}
variable "db_listen_port" {
  description = "host listening port"
}