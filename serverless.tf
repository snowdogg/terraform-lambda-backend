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


variable "engineer" {}