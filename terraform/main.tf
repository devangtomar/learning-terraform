terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = "~> 4.0"
    # }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2_instance" {
  ami           = "abc"
  instance_type = "t2.micro"

  tags = {
    Name : "first-ec2"
  }
}
