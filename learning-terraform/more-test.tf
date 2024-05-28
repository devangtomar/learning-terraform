terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "fdfd"
    region         = "ap-south-1"
    dynamodb_table = "fdfd"
  }
}

output "abc" {
  value = [for name in var.var.usernames : name]
}

locals {
  ingress_rules = [
    {
      port        = "22"
      description = "SSH port for the ingress"
    },
    {
      port        = "80"
      description = "HTTP port for the ingress"
    }
  ]
}

resource "aws_security_group" "new-sg" {
  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

provider "aws" {
  shared_credentials_file = abs("/home/user/credentials.sec")
}

resource "null_resource" "some-script" {

  provisioner "local-exec" {
    command = "echo 'hey I am a provisioner ~ local-exec !'"
  }
  provisioner "file" {
    content = abspath("fdff/fdfd")
    destination = "/home/"
  }
}
