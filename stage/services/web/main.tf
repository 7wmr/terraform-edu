provider "aws" {
  profile    = "default"
  region     = var.aws_region
}

terraform {
  backend "s3" {
    bucket  = "terraform-edu"
    region  = "eu-west-2"
    key     = "stage/services/web/terraform.tfstate"
    encrypt = true    
  }
}

module "services-web" {
  source = "git@github.com:7wmr/terraform-module-edu.git//services/web?ref=master"
    
  aws_region          = var.aws_region
  key_name            = var.key_name

  app_port            = var.app_port
  app_version         = var.app_version

  elb                 = var.elb
  asg                 = var.asg
  
  cluster_name        = var.cluster_name
}

