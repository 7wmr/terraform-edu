data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.20.0.0/16"
  instance_tenancy     = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${terraform.workspace}-main-vpc"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.20.1.0/24"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${terraform.workspace}-public-1-subnet"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.20.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "${terraform.workspace}-private-1-subnet"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.20.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "${terraform.workspace}-private-2-subnet"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${terraform.workspace}-dbs-subnet-group"
  subnet_ids = ["${aws_subnet.private_1.id}", "${aws_subnet.private_2.id}"]

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
    Name = "${terraform.workspace}-main-route-table"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = "${aws_subnet.public_1.id}"
  route_table_id = "${aws_route_table.main.id}"
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = "${aws_subnet.private_1.id}"
  route_table_id = "${aws_route_table.main.id}"
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = "${aws_subnet.private_2.id}"
  route_table_id = "${aws_route_table.main.id}"
}


