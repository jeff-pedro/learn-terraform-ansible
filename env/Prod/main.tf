module "aws-prod" {
  source = "../../infra"
  instancia = "t2.micro"
  aws_image = "ami-008fe2fc65df48dac"
  regiao_aws = "us-west-2"
  chave = "IaC-Prod"
}

output "IP" {
  value = module.aws-prod.public_IP
}