variable "aws_region" {
  default = "eu-west-2"
}

module "vpc" {
  source = "../../modules/vpc"
  env    = "stage"
}