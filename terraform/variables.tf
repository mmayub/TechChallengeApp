variable "name" {
  description = "name of stack, e.g. \"demo\""
}

variable "environment" {
  description = "name of environment, e.g. \"prod\""
}

variable "aws-region" {
  type        = string
  description = "AWS region where infrasturcture is launched"
}

variable "aws-access-key" {
  type = string
  sensitive = true
}

variable "aws-secret-key" {
  type = string
  sensitive = true
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"  
}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

variable "private_subnets" {
  description = "a list of CIDRs for private subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones" 
}

variable "public_subnets" {
  description = "a list of CIDRs for public subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones" 
}

variable "app_port" {
  description = "The port where the app is exposed"
}
variable "health_check_path" {
  description = "Http path for task health check"
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
}

# variable "aws_ecr_repository_url" {
#   description = "URL to ECR repository"
# }

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
}

variable "app_count" {
  description = "Number of apps running in parallel"
}

variable "tag" {
  description = "tag to use for our new docker image"
}

variable "db_name" {
  description = "Name of the DB"
}

variable "db_username" {
  description = "master username"
  sensitive = true
}

variable "db_password" {
  description = "master password"
  sensitive = true
}

variable "db_listen_host" {
  description = "host listening address"
}

variable "db_listen_port" {
  description = "host listening port"
}

# variable "app_security_group" {
#   description = "security group for app"
# }

# variable "db_security_group" {
#   description = "security group for DB"
# }

# variable "certificate_arn" {
#   description = "Regional certificate ARN to be used by the load balancer"
# }

# variable "postgresql_version" {
#   description = "PostgreSQL version to be used"
# }

# variable "db_instance_address" {
#   description = "address of rds instance"
# }

# variable "db_record_name" {
#   description = "route53 record name of rds instance"
# }

# variable "ecs_task_execution_role_name" {
#   description = "ECS task execution role name" 
# }

# variable "ecs_auto_scale_role_name" {
#   description = "ECS auto scale role Name"
# }