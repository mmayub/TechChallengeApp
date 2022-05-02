# output "alb_hostname" {
#   value = module.alb.alb_dns_name
# }

# output "rds_endpoint" {
#   value = module.rds.rds_endpoint
# }

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "db_subnet_group_name" {
  value = module.vpc.db_subnet_group_name
}

output "db_instance_availability_zone" {
  value       = module.rds.db_instance_availability_zone
}