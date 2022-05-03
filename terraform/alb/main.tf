resource "aws_lb" "main" {
  name               = "${var.name}-alb-${var.environment}"
  internal           = false
  security_groups    = [var.alb_security_group]
  subnets            = var.subnets.*.id
  enable_deletion_protection = false
  
  tags = {
    Name        = "${var.name}-alb-${var.environment}"
    Environment = var.environment
  }
}

# redirect all traffic to target group from ALB
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.main.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "main" {
  name        = "${var.name}-tg-${var.environment}"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  # target_type = "ip"
  # target_type = ""

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.name}-tg-${var.environment}"
    Environment = var.environment
  }
}

output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.main.arn
}

output "alb_dns_name" {
  description = "public accessible url to access application"
  value = aws_lb.main.dns_name
}
