resource "aws_security_group" "alb" {
  name   = "${var.name}-sg-alb-${var.environment}"
  vpc_id = var.vpc_id
    
  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description     = "Access to port 80 for users of application"
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.name}-sg-alb-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_security_group" "db" {
  name        = "${var.name}-db-${var.environment}"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups  = [aws_security_group.ecs_tasks.id]
    description     = "Access to port 5432 for application server"
  }
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.name}-db-${var.environment}"
  }
}

output "alb" {
  description = "ID for ALB security group"
  value = aws_security_group.alb.id
}

output "db" {
  description = "ID for db security group"
  value = aws_security_group.ecs_tasks.id
}

# # security group for tasks (in ECS)
# resource "aws_security_group" "ecs_tasks" {
#   name   = "${var.name}-sg-task-${var.environment}"
#   vpc_id = var.vpc_id

#   ingress {
#     protocol         = "tcp"
#     from_port        = var.container_port
#     to_port          = var.container_port
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#     security_groups  = [aws_security_group.alb.id]
#     description     = "Access to port 3000 for load balancer"
#   }

#   egress {
#     protocol         = "-1"
#     from_port        = 0
#     to_port          = 0
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

#   tags = {
#     Name        = "${var.name}-sg-task-${var.environment}"
#     Environment = var.environment
#   }
# }

# output "ecs_tasks" {
#   description = "ID for ecs_tasks security group"
#   value = aws_security_group.ecs_tasks.id
# }