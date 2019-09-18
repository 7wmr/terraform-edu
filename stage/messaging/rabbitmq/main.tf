provider "aws" {
  profile    = "default"
  region     = var.aws_region
}

terraform {
  backend "s3" {
    bucket  = "terraform-edu"
    region  = "eu-west-2"
    key     = "stage/messaging/rabbitmq/terraform.tfstate"
    encrypt = true    
  }
}

module "messaging_rabbitmq" {
  source = "git@github.com:7wmr/terraform-module-edu.git//messaging/rabbitmq?ref=master"
    
  aws_region    = var.aws_region

  rabbitmq      = var.rabbitmq
 
  key_name      = var.key_name
  rabbitmq_name = var.rabbitmq_name
  domain_name   = var.domain_name
}

