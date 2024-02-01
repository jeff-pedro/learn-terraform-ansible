terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_launch_template" "machine" {
  image_id             = var.aws_image
  instance_type        = var.aws_instance
  key_name             = var.key
  security_group_names = [var.aws_security_group]
  user_data            = var.production ? filebase64("ansible.sh") : ""
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.aws_tag_name
    }
  }
}

resource "aws_key_pair" "sshKey" {
  key_name   = var.key
  public_key = file("${var.key}.pub")
}

resource "aws_autoscaling_group" "group" {
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
  name               = var.aws_groupName
  max_size           = var.aws_max
  min_size           = var.aws_min
  target_group_arns  = var.production ? [aws_lb_target_group.loadBalancerTarget[0].arn] : []
  launch_template {
    id      = aws_launch_template.machine.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_schedule" "startMachine" {
  scheduled_action_name  = "startMachine"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 1
  start_time             = timeadd(timestamp(), "10m")
  # O CRON é executado em UTC+0:00. Para executar em UTC-3:00 (Brasil), soma-se 3 horas ao CRON
  # 0 10 * * * (+0:00) ===> 0 9 * * * (-3:00) 
  recurrence             = "0 10 * * MON-FRI"
  autoscaling_group_name = aws_autoscaling_group.group.name
}

resource "aws_autoscaling_schedule" "stopMachine" {
  scheduled_action_name  = "stopMachine"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 1
  start_time             = timeadd(timestamp(), "11m")
  recurrence             = "0 21 * * MON-FRI"  
  autoscaling_group_name = aws_autoscaling_group.group.name
}

resource "aws_default_subnet" "subnet_1" {
  availability_zone = "${var.aws_region}a"
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = "${var.aws_region}b"
}

resource "aws_lb" "loadBalancer" {
  internal = false
  subnets = [
    aws_default_subnet.subnet_1.id,
    aws_default_subnet.subnet_2.id
  ]
  security_groups = [aws_security_group.general_access.id]
  count           = var.production ? 1 : 0
}

resource "aws_default_vpc" "vpc" {
}

resource "aws_lb_target_group" "loadBalancerTarget" {
  name     = "targetMachines"
  port     = "8000"
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.vpc.id
  count    = var.production ? 1 : 0
}


resource "aws_lb_listener" "inputLoadBalancer" {
  load_balancer_arn = aws_lb.loadBalancer[0].arn
  port              = "8000"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.loadBalancerTarget[0].arn
  }
  count = var.production ? 1 : 0
}

resource "aws_autoscaling_policy" "scalingProduction" {
  name                   = "terraformScaling"
  autoscaling_group_name = var.aws_groupName
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
  count = var.production ? 1 : 0
}
