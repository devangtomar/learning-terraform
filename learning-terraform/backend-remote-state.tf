terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "terraform-state"
    key    = "key/terraform.tfstate"
    region = "ap-south-1"
  }
}
