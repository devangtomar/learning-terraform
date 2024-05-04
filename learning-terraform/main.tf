terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = ~> 4.16" ~ no version is specified which makes it pick the latest version..
    }
  }
  # required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "Basic instance"
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/21"
  tags = {
    Name = "green"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.6.0.0/23"
}
