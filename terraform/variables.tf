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

# variable "ecs_task_execution_role_name" {
#   description = "ECS task execution role name" 
# }

# variable "ecs_auto_scale_role_name" {
#   description = "ECS auto scale role Name"
# }

variable "aws-access-key" {
  type = string
  sensitive = true
}

variable "aws-secret-key" {
  type = string
  sensitive = true
}

# variable "az_count" {
#   description = "Number of AZs to cover in a given region"
# }

variable "master_username" {
  type = string
  sensitive = true
}

variable "master_password" {
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

variable "service_desired_count" {
  description = "Number of services running in parallel"
}
variable "postgresql_instance_class" {
  description = "PostgreSQL instance class to be used"
}

# variable "container_count" {
#   description = "Number of docker container to run"
# }

# variable "container_cpu" {
#   description = "The number of cpu units used by the task"
# }

# variable "container_memory" {
#   description = "The amount (in MiB) of memory used by the task"
# }

# variable "container_image" {
#   description = "Application container image"
# }

# variable "certificate_arn" {
#   description = "Regional certificate ARN to be used by the load balancer"
# }

# variable "postgresql_version" {
#   description = "PostgreSQL version to be used"
# }

# variable "tag" {
#   description = "tag to use for our new docker image"
# }

# variable "domain_name" {
#   description = "The domain name to access"
# }
