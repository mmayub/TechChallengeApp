variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

# variable "postgresql_version" {
#   description = "PostgreSQL version to be used"
# }

variable "postgresql_instance_class" {
  description = "PostgreSQL database instance class"
}

variable "master_username" {
  description = "master username"
}

variable "master_password" {
  description = "master password"
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"
}

variable "db_security_groups" {
  description = "ID for db security groups"
}

variable "private_subnets" {
  description = "List of private subnets"
}