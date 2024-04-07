resource "aws_s3_bucket" "for-managing-terraform-state" {
  bucket = "terraform-state"
  lifecycle {
    prevent_destroy = true
  }
}

terraform {
  backend "s3" {
    bucket = "s3-bucket-for-state"
  }
}