# For setting up the secrets.. use

# export TF_VAR_db_username="(YOUR_DB_USERNAME)"
# export TF_VAR_db_password="(YOUR_DB_PASSWORD)"

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true
  username            = var.db_username
  password            = var.db_password
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-up-and-running-state"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-2"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

output "port" {
  value       = aws_db_instance.example.port
  description = "The port the database is listening on"
}

output "address" {
  value       = aws_db_instance.example.address
  description = "Connect to the database at this endpoint"
}

/* If you go back to your web server cluster code, you can get the web server to read
those outputs from the database’s state file by adding the terraform_remote_state
data source in stage/services/webserver-cluster/main.tf:
*/

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = "(YOUR_BUCKET_NAME)"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    # region = "us-east-2"
    region = file('./main.tf') # You can use like as well
  }
}

All of the database’s output variables are stored in the state file, and you can read
them from the terraform_remote_state data source using an attribute reference of
the form:
data.terraform_remote_state.<NAME>.outputs.<ATTRIBUTE>