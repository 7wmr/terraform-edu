provider "aws" {
  profile    = "default"
  region     = var.aws_region
}

terraform {
  backend "s3" {
    bucket  = "terraform-edu"
    region  = "eu-west-2"
    key     = "stage/services/frontend-app/terraform.tfstate"
    encrypt = true    
  }
}

module "terraform-module-edu" {
  source = "git@github.com:7wmr/terraform-module-edu.git?ref=master"
    
  aws_region          = var.aws_region

  server_port         = var.server_port

  elb_port            = var.elb_port
  elb_domain          = var.elb_domain

  min_instance_count  = var.min_instance_count
  max_instance_count  = var.max_instance_count
  
  cluster_name        = var.cluster_name
}

