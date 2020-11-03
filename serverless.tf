provider "aws" { 
  region = "us-west-1"
}

terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    shared_credentials_file = "~/.aws/credentials"
    bucket = "cary-bucket"
    key    = "terraform/terraform.tfstate"
    region = "us-west-1"
    acl = "private"
  }
}

module "VPC" {
    source = "./modules/vpc"

    engineer = var.engineer
}


module "DynamoDB" {
     source = "./modules/DynamoDB"

     engineer = var.engineer
}



module "Lambda" {
  source = "./modules/Lambda"
  private_subnet1 = module.VPC.private_subnet1
  private_subnet2 = module.VPC.private_subnet2
  security_group = module.VPC.security_group
  engineer = var.engineer
}

module "API" {
  source = "./modules/API"

  engineer = var.engineer
  get_arn = module.Lambda.get_arn
  post_arn = module.Lambda.post_arn
  get_name = module.Lambda.get_name
  post_name = module.Lambda.post_name
}

variable "engineer" {}

output "base_url" {
  value = module.API.base_url
}

output "get_arn" {
  value = module.Lambda.get_arn
}