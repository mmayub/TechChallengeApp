### RDS ###
# resource "aws_rds_cluster" "postgres" {
#   cluster_identifier     = "techchallengeservian-db-${var.environment}"
#   db_subnet_group_name   = var.db_subnet_group_name
#   engine                 = "aurora-postgresql"
#   engine_mode            = "provisioned"
#   # engine_version         = var.postgresql_version
#   availability_zones     = var.availability_zones
#   master_username        = var.master_username
#   master_password        = var.master_password
#   database_name          = "app"
#   vpc_security_group_ids = var.db_security_groups
#   deletion_protection    = var.environment == "prod" ? true : false
#   skip_final_snapshot    = var.environment == "prod" ? false : true
# }

# resource "aws_rds_cluster_instance" "cluster_instances" {
#   count               = "1"
#   identifier         = "techchallengeservian-db-${count.index}-${var.environment}"
#   cluster_identifier = aws_rds_cluster.postgres.id
#   instance_class     = var.postgresql_instance_class
#   engine             = aws_rds_cluster.postgres.engine
#   engine_version     = aws_rds_cluster.postgres.engine_version
# }

# output "rds_endpoint" {
#   description = "endpoint of rds cluster"
#   value = aws_rds_cluster.postgres.endpoint
# }

# resource "aws_db_subnet_group" "db-subnet-group" {
#   name       = "techchallangeapp-rds-subnet-group"
#   subnet_ids = data.aws_subnets.available.ids
#   description = "techchallangeapp rds subnet group"

#   lifecycle {
#     create_before_destroy = true
#   }
# }


resource "aws_db_instance" "rds" {
  identifier                = "techchallengeservian-db-${var.environment}"
  allocated_storage         = 20
  max_allocated_storage     = 40
  # storage_type              = "gp2"
  engine                    = "postgres"
  engine_version            = "13.3"
  instance_class            = "db.t3.small"
  username                  = "postgres"
  password                  = "sEcure123"
  port                      = 5432
  publicly_accessible       = false
  # availability_zone         = "ap-southeast-2a"
  # availability_zone        = element(var.availability_zones[count.index], count.index)
  vpc_security_group_ids    = var.db_security_groups
  db_subnet_group_name      = var.db_subnet_group_name
  parameter_group_name      = "default.postgres13"
  # multi_az set to off as it increases dpeloyment time. Set to true for higher db availability.
  multi_az                  = true
  # deletion_protection       = false
  skip_final_snapshot       = true
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value = aws_db_instance.rds.availability_zone
}

