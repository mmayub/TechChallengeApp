output "vpc_id" {
  value = module.vpc.vpc_id
}

output "aws_alb_target_group_arn" {
  value = module.alb.aws_alb_target_group_arn
}

output "alb_security_group" {
  value = module.security_groups.alb
}

output "db_security_group" {
  value = module.security_groups.db
}

output "app_security_group" {
  value = module.security_groups.app
}

output "db_subnet_group_name" {
  value = module.rds.db_subnet_group_name
}

output "subnet_ids" {
  value = data.aws_subnets.available
}
output "db_instance_availability_zone" {
  value       = module.rds.db_instance_availability_zone
}
output "db_instance_address" {
  value = module.rds.db_instance_address
}

output "db_record_name" {
  value = module.route53.db_record_name
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}