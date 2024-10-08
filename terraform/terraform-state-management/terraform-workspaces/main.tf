# We use workspaces for state file isolation for different env : qa, dev, stage and prod

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-up-and-running-state"
    key    = "workspaces-example/terraform.tfstate"
    region = "us-east-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}
