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
