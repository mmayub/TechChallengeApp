variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "db_username" {
  description = "master username"
}

variable "db_password" {
  description = "master password"
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"
}

variable "db_security_groups" {
  description = "ID for db security groups"
}

variable "db_subnet_group_name" {
  description = "db subnet group id"
}