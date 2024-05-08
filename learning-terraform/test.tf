terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "some/random/bucket"
    dynamodb_table = "table_1"
    encrypt        = false
    region         = "ap-south-1"
    key            = "stage/terraform-stg.tfstate"
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2_1" {
  ami               = data.aws_ami.ubuntu.id
  availability_zone = "ap-south-1b"
  instance_type     = "t2.micro"
  user_data         = <<-EOF
    #!/bin/bash
    echo 'hey we are running a script inside newly created instance!'
    EOF
  tags = {
    "Name" = "Test EC2 instance"
  }
}

resource "aws_alb" "application_load_balancer" {

  lifecycle {
    prevent_destroy = false
  }
}

resource "null_resource" "name" {
  for_each = aws_alb.application_load_balancer.security_groups
  
}