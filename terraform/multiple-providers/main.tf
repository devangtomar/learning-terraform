# Terraform block with multiple providers

terraform {
  required_providers {
    aws = {
      #   version = "~> 4.0"
      source = "hashicorp/aws"
    }
    azurerm = {
      #   version = "~> 5.0"
      source = "hashicorp/azurerm"
    }
  }
}

# How to handle if you want to deploy in different regions via same provider..

provider "aws" {
  region = "ap-south-1"
  alias  = "region_1"
}

provider "aws" {
  region = "az-south-1"
  alias  = "region_2"
}

# Now we can use data source

data "aws_region" "region_1" {
  provider = aws.region_1
}

data "aws_region" "region_2" {
  provider = aws.region_2
}

data "aws_ami" "ubuntu_region_1" {
  provider = aws.region_1
  owners = [ "099999989" ]
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

output "region_1" {
  value       = data.aws_region.region_1.name
  description = "The name of the first region"
}

output "region_1" {
  value       = data.aws_region.region_2.name
  description = "The name of the second region"
}

# Same with resources too..

resource "aws_iam_user" "region_1_iam_user" {
  provider = aws.region_1
  name = "developer"
  tags = {
    Name = "dev-role"
    Environment = "stage"
  }
}