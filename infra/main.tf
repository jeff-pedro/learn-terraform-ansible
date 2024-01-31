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
  user_data            = filebase64("ansible.sh")
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.aws_tag_name
    }
  }
}

resource "aws_key_pair" "keyPair" {
  key_name   = var.key
  public_key = file("${var.key}.pub")
}

resource "aws_autoscaling_group" "group" {
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
  name               = var.aws_groupName
  max_size           = var.aws_max
  min_size           = var.aws_min
  target_group_arns  = [aws_lb_target_group.loadBalancerTarget.arn]
  launch_template {
    id      = aws_launch_template.machine.id
    version = "$Latest"
  }
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
}

resource "aws_default_vpc" "vpc" {
}

resource "aws_lb_target_group" "loadBalancerTarget" {
  name     = "targetMachines"
  port     = "8000"
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.vpc.id
}


resource "aws_lb_listener" "inputLoadBalancer" {
  load_balancer_arn = aws_lb.loadBalancer.arn
  port              = "8000"
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.loadBalancerTarget.arn
  }
}
