terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
  shared_credentials_file = "./creds.txt"
}

locals {
  staging_env = "staging"
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${local.staging_env}-vpc-tag"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/16"
  availability_zone = var.availability_zone
  tags = {
    Name = "${local.staging_env}-subnet-tag"
  }
}

resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${local.staging_env}-Internet Gateway"
  }
}

resource "aws_route_table" "my_vpc_eu_central_1c_public" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_vpc_igw.id
  }
  tags = {
    Name = "${local.staging_env}- Public Subnet Route Table"
  }
}
resource "aws_route_table_association" "my_vpc_eu_central_1c_public" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_vpc_eu_central_1c_public.id
  lifecycle {
    create_before_destroy = false
    prevent_destroy       = false
    # ignore_changes        = [tags]
  }
}

resource "aws_instance" "ec2_example" {

  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.my_subnet.id
  associate_public_ip_address = true

  tags = {
    Name = var.tag
  }
  lifecycle {
    create_before_destroy = false # By default, when Terraform must change a resource argument that cannot be updated in-place due to remote API limitations, Terraform will instead destroy the existing object and then create a new replacement object with the new configured arguments.
    prevent_destroy       = false # This meta-argument, when set to true, will cause Terraform to reject with an error any plan that would destroy the infrastructure object associated with the resource, as long as the argument remains present in the configuration.
    # ignore_changes        = [tags] # Ignore changes to tags, e.g. because a management agent
    # updates these based on some ruleset managed elsewhere.
  }
}
