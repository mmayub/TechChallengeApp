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

variable "db-key" {
  type = string
  sensitive = true
}

variable "db-secret" {
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

variable "service_desired_count" {
  description = "Number of tasks running in parallel"
}

variable "container_port" {
  description = "The port where the Docker is exposed"
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
}
variable "container_image" {
  description = "Application container image"

}
variable "health_check_path" {
  description = "Http path for task health check"
}

variable "certificate_arn" {
  description = "Regional certificate ARN to be used by the load balancer"
}

variable "postgresql_version" {
  description = "PostgreSQL version to be used"
}