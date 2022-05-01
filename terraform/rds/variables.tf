variable "postgresql_version" {
  description = "PostgreSQL version to be used"
}

variable "postgresql_instance_class" {
  description = "PostgreSQL database instance class"
  default     = "db.t3.medium"
}

variable "db-key" {
  description = "DB key"
}

variable "db-secret" {
  description = "DB secret"
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"
}