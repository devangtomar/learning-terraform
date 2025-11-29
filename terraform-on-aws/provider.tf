terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">=1.5.7"
}

provider "aws" {
  region = "ap-south-1"
}

locals {
  staging_env = "staging"
}

output "region" {
  value = aws_instance.instance_created_via_terraform.region
}

output "instance_ips" {
  value = {
    region    = aws_instance.instance_created_via_terraform.region
    public_ip = aws_instance.instance_created_via_terraform.public_ip
  }
}