provider "aws" {
  profile    = "default"
  region     = var.aws_region
#  access_key = ""
#  secret_key = ""
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
  source      = "git@github.com:7wmr/terraform-module-edu.git//msg/rabbitmq?ref=master"
  environment = "${terraform.workspace}"

  vpc_id      = "${aws_vpc.main.id}"
  subnet_id   = "${aws_subnet.private_1.id}"

  key_name    = var.key_name
  ssh_enabled = false

  msg         = var.rabbitmq
}

module "dbs_mysql" {
  source      = "git@github.com:7wmr/terraform-module-edu.git//dbs/mysql?ref=master"
  environment = "${terraform.workspace}"

  vpc_id              = "${aws_vpc.main.id}"
  subnet_group_name   = "${aws_db_subnet_group.main.name}"

  dbs                 = var.mysql
}

module "svc_web" {
  source               = "git@github.com:7wmr/terraform-module-edu.git//svc/web?ref=master"  
  environment          = "${terraform.workspace}"

  vpc_id               = "${aws_vpc.main.id}"
  subnet_ids           = ["${aws_subnet.public_1.id}", "${aws_subnet.public_2.id}"]
  
  key_name             = var.key_name
  ssh_enabled          = true

  rabbitmq_endpoint    = "${module.msg_rabbitmq.endpoint}"
  rabbitmq_credentials = "${var.rabbitmq.username}:${var.rabbitmq.password}"

  app                  = var.web_app
  elb                  = var.web_elb
  asg                  = var.web_asg
}

module "svc_run" {
  source               = "git@github.com:7wmr/terraform-module-edu.git//svc/run?ref=master"
  environment          = "${terraform.workspace}"

  vpc_id               = "${aws_vpc.main.id}"
  subnet_id            = "${aws_subnet.private_1.id}"

  key_name             = var.key_name
  ssh_enabled          = true

  rabbitmq_endpoint    = "${module.msg_rabbitmq.endpoint}"
  rabbitmq_credentials = "${module.msg_rabbitmq.svc_username}:${module.msg_rabbitmq.svc_password}"

  mysql_endpoint       = "${module.dbs_mysql.endpoint}"
  mysql_credentials    = "${var.mysql.username}:${var.mysql.password}"

  app                  = var.run_app
}

