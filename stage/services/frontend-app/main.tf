provider "aws" {
  profile    = "default"
  region     = "eu-west-2"
}


terraform {
  backend "s3" {
    bucket  = "terraform-edu"
    region  = "eu-west-2"
    key     = "stage/services/frontend-app/terraform.tfstate"
    encrypt = true    
  }
}

resource "aws_security_group" "web" { 
  name = "terraform-secgroup-web" 
  ingress { 
    from_port = "${var.elb_port}" 
    to_port = "${var.elb_port}" 
    protocol = "tcp" 
    cidr_blocks = [ "0.0.0.0/0" ] 
  } 
  lifecycle { 
    create_before_destroy = true 
  } 
}

resource "aws_elb" "web" {
  name               = "terraform-elb-web"
  availability_zones = "${data.aws_availability_zones.available.names}"
  security_groups = ["${aws_security_group.web.id}"]
  
  access_logs {
    bucket        = "terraform-edu"
    bucket_prefix = "logs/frontend-app"
    interval      = 60
    enabled       = false
  }

  listener {
    instance_port     = "${var.web_port}"
    instance_protocol = "http"
    lb_port           = "${var.elb_port}"
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.web_port}/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "terraform-elb-web"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_autoscaling_group" "web" {
  launch_configuration = "${aws_launch_configuration.web.id}"
  availability_zones = "${data.aws_availability_zones.available.names}"
  min_size = 2 
  max_size = 10
  load_balancers = ["${aws_elb.web.id}"]
  tag { 
    key = "Name" 
    value = "terraform-asg-web" 
    propagate_at_launch = true 
  }
  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" { 
  template = "${file("user-data.sh")}" 
  vars = { 
    web_port = "${var.web_port}" 
  } 
}

resource "aws_launch_configuration" "web" { 
  image_id = "ami-077a5b1762a2dde35" 
  instance_type = "t2.micro" 
#  security_groups = [ "${aws_security_group.web.id}" ] 
  user_data = "${data.template_file.user_data.rendered}" 

  lifecycle { 
    create_before_destroy = true 
  } 
}

