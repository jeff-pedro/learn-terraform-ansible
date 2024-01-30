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

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.aws_tag_name
    }
  }
}

resource "aws_instance" "template_instance" {
  launch_template {
    id      = aws_launch_template.machine.id
    version = "$Latest"
  }
}

resource "aws_key_pair" "aws_key" {
  key_name   = var.key
  public_key = file("${var.key}.pub")
}

# output "public_IP" {
#   value = template_instance.machine.public_ip
# }
