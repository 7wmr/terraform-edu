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

resource "aws_subnet" "public_1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.2.0/23"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "${terraform.workspace}-public-1-subnet"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.12.0/23"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "${terraform.workspace}-private-1-subnet"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.14.0/23"
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

resource "aws_eip"  "main" {
  vpc = true
}

resource "aws_nat_gateway" "main" {
  allocation_id = "${aws_eip.main.id}"
  subnet_id     = "${aws_subnet.public_1.id}"
  depends_on    = ["aws_internet_gateway.main"]
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags = {
    Name = "${terraform.workspace}-public-route-table"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = "${aws_subnet.public_1.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.main.id}"
  }

  tags = {
    Name = "${terraform.workspace}-private-route-table"
  } 
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = "${aws_subnet.private_1.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = "${aws_subnet.private_2.id}"
  route_table_id = "${aws_route_table.private.id}"
}


