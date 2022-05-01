resource "aws_rds_cluster" "postgres" {
  cluster_identifier     = "techchallengeservian-db-${var.environment}"
  engine                 = "aurora-postgresql"
  engine_mode            = "provisioned"
  # engine_version         = var.postgresql_version
  availability_zones     = var.availability_zones
  # master_username        = values(var.application-secrets)[0]
  # master_password        = values(var.application-secrets)[1]
  master_username        = var.master_username
  master_password        = var.master_password
  database_name          = "app"
  vpc_security_group_ids = var.db_security_groups
  deletion_protection    = var.environment == "prod" ? true : false
  skip_final_snapshot    = var.environment == "prod" ? false : true
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier         = "techchallengeservian-db-${var.environment}"
  cluster_identifier = aws_rds_cluster.postgres.id
  instance_class     = var.postgresql_instance_class
  engine             = aws_rds_cluster.postgres.engine
  engine_version     = aws_rds_cluster.postgres.engine_version
}


