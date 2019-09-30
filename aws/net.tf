resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${terraform.workspace}-main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${terraform.workspace}-public-subnet"
  }
}

resource "aws_subnet" "private_primary" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "${terraform.workspace}-private-primary-subnet"
  }
}

resource "aws_subnet" "private_secondary" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "${terraform.workspace}-private-secondary-subnet"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${terraform.workspace}-dbs-subnet-group"
  subnet_ids = ["${aws_subnet.private_primary.id}", "${aws_subnet.private_secondary.id}"]

  tags = {
    Name = "${terraform.workspace}-dbs-subnet-group"
  }
}


resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${terraform.workspace}-internet-gateway"
  }
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags = {
    Name = "${terraform.workspace}-route-table"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.main.id}"
}

