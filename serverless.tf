provider "aws" { 
  region = "us-west-1"
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

  engineer = var.engineer
}

module "API" {
  source = "./modules/API"

  engineer = var.engineer
  get_arn = module.Lambda.get_arn
  post_arn = module.Lambda.post_arn
}

variable "engineer" {}

output "base_url" {
  value = module.API.base_url
}