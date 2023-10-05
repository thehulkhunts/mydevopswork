provider "aws" {
    region = "ap-south-1"
    access_key = "your-access-key"
    secret_key = "your-secret-key"
}

terraform {
  required_version = ">= 1.5.7"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">= 5.17.0"
    }
  }
}

terraform {
  backend "s3" {
      bucket = "terraform-buc-01"
      key = "jenkins-slave/terraform.tfstate"
      region = "ap-south-1"
      dynamodb_table = "Terraform-dynamoDB-table"
  }
}

module "module-jenkins-slave" {
   source = "../module-jenkins-slave"
   security_groups = module.module-security-group.jenkins_security
}
module "module-security-group" {
  source = "../module-security-group"
}