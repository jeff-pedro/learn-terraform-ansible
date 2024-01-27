module "aws-dev" {
  source = "../../infra"
  instancia = "t2.micro"
  aws_image = "ami-053b0d53c279acc90"
  regiao_aws = "us-east-1"
  chave = "IaC-DEV"
}

output "IP" {
  value = module.aws-dev.public_IP
}
