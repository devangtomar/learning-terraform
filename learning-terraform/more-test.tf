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
  value = [for name in var.var.usernames: name]
}