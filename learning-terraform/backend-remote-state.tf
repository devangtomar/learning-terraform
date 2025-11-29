terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "terraform-state"
    dynamodb_endpoint = "value"
    dynamodb_table = "value"
    key    = "key/terraform.tfstate"
    region = "ap-south-1"
  }
}
