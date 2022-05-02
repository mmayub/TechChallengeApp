### RDS ###
resource "aws_db_subnet_group" "db-subnet-group" {
  name = "${var.name}-${var.environment}-db-subnet-group"
  description = "${var.name}-${var.environment} DB Subnet group"
  subnet_ids = ["${var.private_subnets.*.id}"]
  # tags {
  #   Name = "${var.name}-${var.environment}-db-subnet-group"
  #   Environment = "${var.environment}"
  # }
}

resource "aws_rds_cluster" "postgres" {
  cluster_identifier     = "techchallengeservian-db-${var.environment}"
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-group.id
  engine                 = "aurora-postgresql"
  engine_mode            = "provisioned"
  # engine_version         = var.postgresql_version
  availability_zones     = var.availability_zones
  master_username        = var.master_username
  master_password        = var.master_password
  database_name          = "app"
  vpc_security_group_ids = var.db_security_groups
  deletion_protection    = var.environment == "prod" ? true : false
  skip_final_snapshot    = var.environment == "prod" ? false : true
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count               = "1"
  identifier         = "techchallengeservian-db-${count.index}-${var.environment}"
  cluster_identifier = aws_rds_cluster.postgres.id
  instance_class     = var.postgresql_instance_class
  engine             = aws_rds_cluster.postgres.engine
  engine_version     = aws_rds_cluster.postgres.engine_version
}

output "rds_endpoint" {
  description = "endpoint of rds cluster"
  value = aws_rds_cluster.postgres.endpoint
}
# resource "aws_db_instance" "rds" {
#     identifier                = "techchallengeservian-db-${var.environment}"
#     allocated_storage         = 20
#     max_allocated_storage     = 40
#     storage_type              = "gp2"
#     engine                    = "postgres"
#     engine_version            = "12.5"
#     instance_class            = "db.t2.micro"
#     username                  = "postgres"
#     password                  = "letmein123"
#     port                      = 5432
#     publicly_accessible       = false
#     availability_zone         = "ap-southeast-2a"
#     vpc_security_group_ids    = var.db_security_groups
#     db_subnet_group_name      = aws_db_subnet_group.db-subnet-group.id
#     parameter_group_name      = "default.postgres12"
#     # multi_az set to off as it increases dpeloyment time. Set to true for higher db availability.
#     multi_az                  = false
#     deletion_protection       = false
#     skip_final_snapshot       = true
# }
