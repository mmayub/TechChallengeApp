output "vpc_id" {
  value = module.vpc.vpc_id
}

output "db_subnet_group_name" {
  value = module.vpc.db_subnet_group_name
}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
output "db_instance_availability_zone" {
  value       = module.rds.db_instance_availability_zone
}
output "rds_instance_address" {
  value = module.rds.rds_instance_address
}

output "rds_record_name" {
  value = module.route53.rds_record_name
}