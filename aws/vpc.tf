data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/20"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${terraform.workspace}-main-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${terraform.workspace}-internet-gateway"
  }
}

resource "aws_eip"  "main" {
  vpc = true
}

resource "aws_nat_gateway" "main" {
  allocation_id = "${aws_eip.main.id}"
  subnet_id     = "${aws_subnet.public_1.id}"
  depends_on    = ["aws_internet_gateway.main"]
}


