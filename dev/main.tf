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

resource "aws_iam_server_certificate" "test_cert" {
  name             = "some_test_cert"
  certificate_body = "${file("self-ca-cert.pem")}"
  private_key      = "${file("test-key.pem")}"
}



module "msg_rabbitmq" {
  source   = "git@github.com:7wmr/terraform-module-edu.git//msg/rabbitmq?ref=master"
    
  key_name    = var.key_name
  ssh_enabled = false

  msg         = var.rabbitmq
}

module "dbs_mysql" {
  source = "git@github.com:7wmr/terraform-module-edu.git//dbs/mysql?ref=master"

  dbs    = var.mysql
}

module "svc_web" {
  source   = "git@github.com:7wmr/terraform-module-edu.git//svc/web?ref=master"

  key_name             = var.key_name
  ssh_enabled          = false

  rabbitmq_endpoint    = "${module.msg_rabbitmq.endpoint}"
  rabbitmq_credentials = "${var.rabbitmq.username}:${var.rabbitmq.password}"

  app                  = var.web_app
  elb                  = var.web_elb
  asg                  = var.web_asg
}

module "svc_run" {
  source   = "git@github.com:7wmr/terraform-module-edu.git//svc/run?ref=master"

  key_name             = var.key_name
  ssh_enabled          = true

  rabbitmq_endpoint    = "${module.msg_rabbitmq.endpoint}"
  rabbitmq_credentials = "${module.msg_rabbitmq.svc_username}:${module.msg_rabbitmq.svc_password}"

  mysql_endpoint       = "${module.dbs_mysql.endpoint}"
  mysql_credentials    = "${var.mysql.username}:${var.mysql.password}"

  app                  = var.run_app
}


