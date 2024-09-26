provider "aws" {
  region  = "ap-south-1"
  profile = "vinay"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.61.0"
    }
  }
  required_version = ">=1.9.1"
}

module "networking" {
  source = "../networking"
}
module "instances" {
  source                 = "../Instances"
  subnet_id              = module.networking.public_subnets
  vpc_security_group_ids = module.networking.vpc_security_groups
}