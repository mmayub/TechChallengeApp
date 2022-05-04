data "aws_ami" "amazon-linux-2" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name   = "owner-alias"
        values = ["amazon"]
    }

    filter {
        name   = "architecture"
        values = ["x86_64"]
    }

    filter {
        name   = "name"
        values = ["amzn2-ami-hvm*"]
    }
}

resource "aws_key_pair" "deploy_key" {
  key_name   = "${var.name}-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}

resource "aws_launch_configuration" "launch-configuration" {
    name_prefix   = "techchallengeapp-launch-configuration"
    image_id      = data.aws_ami.amazon-linux-2.id
    instance_type = "t2.micro"
    user_data     = file("${path.module}/install.sh") 
    security_groups= [var.app_security_group]
    key_name      = "${var.name}-key" 
    
    root_block_device {
        volume_size = 20
    }
    
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "autoscaling-group" {
    name                 = "techchallengeapp-asg"
    launch_configuration = aws_launch_configuration.launch-configuration.name
    vpc_zone_identifier  = var.vpc_zone_identifier
    target_group_arns    = [var.aws_alb_target_group_arn]

    max_size = 5
    min_size = 2

    tag {
        key                 = "Name"
        value               = "${var.name}-${var.environment}"
        propagate_at_launch = true
    }

    # depends_on = [
    #     aws_db_instance.rds,
    #     aws_route53_record.private-db-record
    # ]
}