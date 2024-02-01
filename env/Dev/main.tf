module "aws-dev" {
  source             = "../../infra"
  aws_instance       = "t2.micro"
  aws_image          = "ami-053b0d53c279acc90"
  aws_region         = "us-east-1"
  aws_tag_name       = "Project DEV"
  aws_security_group = "DEV"
  aws_groupName      = "DEV"
  aws_min            = 0
  aws_max            = 1
  key                = "IaC-DEV"
  production         = false
}
