module "aws-prod" {
  source             = "../../infra"
  aws_instance       = "t2.micro"
  aws_image          = "ami-053b0d53c279acc90"
  aws_region         = "us-east-1"
  aws_tag_name       = "Project Prod"
  aws_security_group = "prod_general_access"
  key                = "IaC-Prod"
}

output "IP" {
  value = module.aws-prod.public_IP
}
