# This is for locking ~ As soon as data is shared, you run into a new problem: locking. Without locking,
# if two team members are running Terraform at the same time, you can run into
# race conditions as multiple Terraform processes make concurrent updates to the
# state files, leading to conflicts, data loss, and state file corruption

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
