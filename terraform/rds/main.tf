# db subnet group
resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "techchallangeapp-rds-subnet-group"
  subnet_ids = var.db_subnets
  description = "techchallangeapp rds subnet group"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "rds" {
  identifier                = "techchallenge-db-${var.environment}"
  allocated_storage         = 20
  max_allocated_storage     = 40
  engine                    = "postgres"
  engine_version            = "13.3"
  instance_class            = "db.t3.small"
  # name                      = "app"
  username                  = var.db_username
  password                  = var.db_password
  port                      = 5432
  publicly_accessible       = false
  vpc_security_group_ids    = var.db_security_groups
  db_subnet_group_name      = aws_db_subnet_group.db-subnet-group.id
  parameter_group_name      = "default.postgres13"
  multi_az                  = true
  skip_final_snapshot       = true

  tags = {
    Name = "${var.name}-db-${var.environment}"
  }
}

output "db_instance_address" {
  description = "The adress of RDS instance"
  value = aws_db_instance.rds.address
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value = aws_db_instance.rds.availability_zone
}

output "db_subnet_group_name" {
  description = "db subnet group id"
  value = aws_db_subnet_group.db-subnet-group.id
}

