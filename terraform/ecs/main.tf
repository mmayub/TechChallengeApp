# adding IAM roles to execute tasks
data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}-ecs-task-execution-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# cloudwatch log group
resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/${var.name}-task-${var.environment}"
  retention_in_days = 30
  tags = {
    Name        = "${var.name}-task-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_stream" "cb_log_stream" {
  name           = "${var.name}-log-stream-${var.environment}"
  log_group_name = aws_cloudwatch_log_group.main.name
}

# creating ECS cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.name}-cluster-${var.environment}"
  tags = {
    Name        = "${var.name}-cluster-${var.environment}"
    Environment = var.environment
  }
}

# ECS cluster task definition
resource "aws_ecs_task_definition" "main" {
  family                   = "${var.name}-task-${var.environment}"
  requires_compatibilities = ["FARGATE"]  
  network_mode             = "awsvpc"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode(
    [
      {
        name        = "${var.name}-container-${var.environment}"
        image       = var.container_image
        # image       = var.aws_ecr_repository_url
        cpu         = var.container_cpu
        memory      = var.container_memory
        network_mode             = "awsvpc"
        essential   = true
        # environment = var.container_environment
        command     = ["serve"]
        portMappings = [
          {
            protocol      = "tcp"
            containerPort = var.container_port
            hostPort      = var.container_port
          }
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.main.name
            awslogs-stream-prefix = "ecs"
            awslogs-region        = var.region
          }
        }
      }
    ]
  )

  tags = {
    Name        = "${var.name}-task-${var.environment}"
    Environment = var.environment
  }
}

# ECS service
resource "aws_ecs_service" "main" {
  name                               = "${var.name}-service-${var.environment}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = var.service_desired_count
  # deployment_minimum_healthy_percent = 50
  # deployment_maximum_percent         = 200
  # health_check_grace_period_seconds  = 60
  launch_type                        = "FARGATE"
  # scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = var.ecs_service_security_groups
    subnets          = var.subnets.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name   = "${var.name}-container-${var.environment}"
    container_port   = var.container_port
  }

  # we ignore task_definition changes as the revision changes on deploy
  # of a new version of the application
  # desired_count is ignored as it can change due to autoscaling policy
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

# autoscaling
resource "aws_iam_role" "autoscale_role" {
  name = "fargate-autoscale-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "application-autoscaling.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 6
  min_capacity       = 3
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = aws_iam_role.autoscale_role.arn
  service_namespace  = "ecs"
}

# Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "up" {
  name               = "${var.name}-scale-up-${var.environment}"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.ecs_target]
}

# Automatically scale capacity down by one
resource "aws_appautoscaling_policy" "down" {
  name               = "${var.name}-scale-down-${var.environment}"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.ecs_target]
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "${var.name}-${var.environment}-cpu-utilization-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.main.name
  }

  alarm_actions = [aws_appautoscaling_policy.up.arn]
}

# CloudWatch alarm that triggers the autoscaling down policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "${var.name}-${var.environment}-cpu-utilization-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.main.name
  }

  alarm_actions = [aws_appautoscaling_policy.down.arn]
}


# # based on memory usage
# resource "aws_appautoscaling_policy" "ecs_policy_memory" {
#   name               = "memory-autoscaling"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.ecs_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageMemoryUtilization"
#     }

#     target_value       = 80
#     scale_in_cooldown  = 300
#     scale_out_cooldown = 300
#   }
# }

# # based on cpu usage
# resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
#   name               = "cpu-autoscaling"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.ecs_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }

#     target_value       = 60
#     scale_in_cooldown  = 300
#     scale_out_cooldown = 300
#   }
# }



