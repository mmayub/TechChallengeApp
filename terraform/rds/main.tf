resource "aws_rds_cluster" "postgres" {
  cluster_identifier     = "${var.name}-db-${var.env}"
  engine                 = "aurora-postgresql"
  engine_mode            = "provisioned"
  engine_version         = var.postgresql_version
  availability_zones     = var.availability_zones
  master_username        = lookup(var.application_secrets, "DB_KEY", "default")
  master_password        = lookup(var.application_secrets, "DB_SECRET", "default")
  database_name          = "app"
  vpc_security_group_ids = [aws_security_group.db.id]
  deletion_protection    = var.environment == "prod" ? true : false
  skip_final_snapshot    = var.environment == "prod" ? false : true
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier         = "${var.name}-db-${var.environment}"
  cluster_identifier = aws_rds_cluster.postgres.id
  instance_class     = var.postgresql_instance_class
  engine             = aws_rds_cluster.postgres.engine
  engine_version     = aws_rds_cluster.postgres.engine_version
}

