provider "aws" {
  profile    = "default"
  region     = var.aws_region
}

terraform {
  backend "s3" {
    bucket  = "terraform-edu"
    region  = "eu-west-2"
    key     = "stage/database/mysql/terraform.tfstate"
    encrypt = true    
  }
}

module "database_mysql" {
  source = "git@github.com:7wmr/terraform-module-edu.git//databases/mysql?ref=master"

  mysql        = var.mysql
  cluster_name = var.cluster_name
}

