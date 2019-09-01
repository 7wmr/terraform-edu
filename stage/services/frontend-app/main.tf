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
    from_port = "${var.web_port}" 
    to_port = "${var.web_port}" 
    protocol = "tcp" 
    cidr_blocks = [ "0.0.0.0/0" ] 
  } 
  lifecycle { 
    create_before_destroy = true 
  } 
}

data "aws_availability_zones" "all" {} 

resource "aws_autoscaling_group" "web" {
  launch_configuration = "${aws_launch_configuration.web.id}"
  availability_zones = [ "${data.aws_availability_zones.all.names}" ]
  min_size = 2 
  max_size = 10 
  tag { 
    key = "Name" 
    value = "terraform-asg-web" 
    propagate_at_launch = true 
  } 
}

data "template_file" "user_data" { 
  template = "${file("user-data.sh")}" 
  vars = { 
    web_port = "${var.web_port}" 
  } 
}

resource "aws_launch_configuration" "web" { 
  image_id = "ami-40d28157" 
  instance_type = "t2.micro" 
  security_groups = [ "${aws_security_group.web.id}" ] 
  user_data = "${data.template_file.user_data.rendered}" 

  lifecycle { 
    create_before_destroy = true 
  } 
}

