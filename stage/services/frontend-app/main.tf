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

resource "aws_security_group" "elb" { 
  name = "terraform-secgroup-elb" 
  ingress { 
    from_port   = "${var.elb_port}" 
    to_port     = "${var.elb_port}" 
    protocol    = "tcp" 
    cidr_blocks = [ "0.0.0.0/0" ] 
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle { 
    create_before_destroy = true 
  } 
}

resource "aws_security_group" "web" { 
  name = "terraform-secgroup-web" 
  ingress { 
    from_port = "${var.server_port}" 
    to_port = "${var.server_port}" 
    protocol = "tcp" 
    cidr_blocks = [ "0.0.0.0/0" ] 
  } 
  lifecycle { 
    create_before_destroy = true 
  } 
}

data "aws_route53_zone" "primary" {
  name         = "${var.elb_domain}."
  private_zone = false
}

resource "aws_route53_record" "web" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.elb_record}.${var.elb_domain}"
  type    = "A"
  alias {
    name                   = "${aws_elb.web.dns_name}"
    zone_id                = "${aws_elb.web.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_elb" "web" {
  name               = "terraform-elb-web"
  availability_zones = "${data.aws_availability_zones.available.names}"
  security_groups    = ["${aws_security_group.elb.id}"]
 
  access_logs {
    bucket        = "terraform-edu"
    bucket_prefix = "access-logs"
    interval      = 60
    enabled       = false
  }

  listener {
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
    lb_port           = "${var.elb_port}"
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.server_port}/"
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
  launch_configuration       = "${aws_launch_configuration.web.id}"
  availability_zones         = "${data.aws_availability_zones.available.names}"
  min_size                   = 2 
  max_size                   = 10
  health_check_type          = "ELB"
  load_balancers             = ["${aws_elb.web.name}"]
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
    server_port = "${var.server_port}"
  } 
}

resource "aws_launch_configuration" "web" { 
  image_id = "ami-077a5b1762a2dde35" 
  instance_type = "t2.micro" 
  security_groups = [ "${aws_security_group.web.id}" ] 
  user_data = "${data.template_file.user_data.rendered}" 

  lifecycle { 
    create_before_destroy = true 
  } 
}

