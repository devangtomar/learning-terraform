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
  ami                    = "ami-0d0bed6857ceeda4b" # AMI for Amazon linux..
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data              = <<-EOF
  #!/bin/bash
  echo 'Hello world!' > index.html
  nohup busybox httpd -f -p 8080 &
  EOF

  tags = {
    Name : "first-ec2-via-terraform"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "id" {
  # value = aws_instance.ec2_instance.id
  value = aws_security_group.instance.id
}
