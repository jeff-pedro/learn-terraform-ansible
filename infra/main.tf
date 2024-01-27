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
  region = var.regiao_aws
}

resource "aws_instance" "app_server" {
  ami           = var.aws_image
  instance_type = var.instancia
  key_name      = var.chave
  
  tags = {
    Name = "Terraform Ansible Python"
  }
}

resource "aws_key_pair" "awsChave" {
  key_name =  var.chave
  public_key = file("${var.chave}.pub")
}

output "public_IP" {
  value = aws_instance.app_server.public_ip
}
