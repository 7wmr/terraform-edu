provider "aws" {
  profile    = "default"
  region     = var.aws_region
}

terraform {
  backend "s3" {
    bucket  = "terraform-edu"
    region  = "eu-west-2"
    key     = "dev/terraform.tfstate"
    encrypt = true    
  }
}

module "msg_rabbitmq" {
  source   = "git@github.com:7wmr/terraform-module-edu.git//msg/rabbitmq?ref=master"
    
  key_name = var.key_name

  msg      = var.rabbitmq
}

module "dbs_mysql" {
  source = "git@github.com:7wmr/terraform-module-edu.git//dbs/mysql?ref=master"

  dbs    = var.mysql
}

module "svc_web" {
  source   = "git@github.com:7wmr/terraform-module-edu.git//svc/web?ref=master"

  key_name = var.key_name

  app      = var.web_app
  elb      = var.web_elb
  asg      = var.web_asg
}

