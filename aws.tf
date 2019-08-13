provider "aws" {
  profile    = "default"
  region     = "eu-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0a0cb6c7bcb2e4c51"
  instance_type = "t2.micro"
}

