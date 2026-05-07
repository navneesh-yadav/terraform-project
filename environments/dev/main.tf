terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. Build the Network
module "vpc" {
  source       = "../../modules/vpc"
  vpc_cidr     = "10.0.0.0/16"
  environment  = "dev"
  project_name = "oidc-portfolio"
}

# 2. Build the Server inside the Network
module "ec2" {
  source      = "../../modules/ec2"
  vpc_id      = module.vpc.vpc_id       # Grabs the VPC ID from the module above
  subnet_id   = module.vpc.subnet_id    # Grabs the Subnet ID from the module above
  environment = "dev"
}
