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
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "terraform"

  tags = {
    Name = "Terraform Ansible Python"
  }
}
