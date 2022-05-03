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

resource "aws_launch_configuration" "launch-configuration" {
    name_prefix   = "techchallengeapp-launch-configuration"
    image_id      = data.aws_ami.amazon-linux-2.id
    instance_type = "t2.micro"
    user_data     = filebase64("install.sh")
    security_groups  = [aws_security_group.app-security-group.id]

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
    vpc_zone_identifier  = [aws_subnet.app-subnet-az1.id, aws_subnet.app-subnet-az2.id, aws_subnet.app-subnet-az3.id]
    target_group_arns    = [aws_lb_target_group.target-group.arn]

    max_size = 5
    min_size = 2

    depends_on = [
        aws_db_instance.rds,
        aws_route53_record.private-db-record
    ]
}