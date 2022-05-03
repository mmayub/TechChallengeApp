output "vpc_id" {
  value = module.vpc.vpc_id
}

output "db_subnet_group_name" {
  value = module.vpc.db_subnet_group_name
}

output "db_instance_availability_zone" {
  value       = module.rds.db_instance_availability_zone
}
output "rds_instance_address" {
  value = module.rds.rds_instance_address
}