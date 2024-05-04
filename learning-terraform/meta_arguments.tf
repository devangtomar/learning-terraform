variable "usernames" {
  type        = list(string)
  description = "IAM username"
  default     = ["user1", "user2", "user3", "user4"]
}

resource "aws_iam_user" "user_example" {
  count = length(var.usernames)
  name  = var.usernames[count.index]
}

variable "more_usernames" {
  type        = set(string)
  description = "More IAM usernames"
  default     = ["user1", "user2", "user3", "user4"]
}

resource "aws_iam_user" "more_user_example" {
  for_each = var.more_usernames
  name     = each.value
}

output "print_the_names" {
  value = [for name in var.usernames : name]
}

resource "aws_instance" "ec2_1" {
  instance_type = var.instance_type
  ami           = data.aws_ami.ubuntu.id
  tags = {
    "Name" = "stage"
  }
  lifecycle {
    prevent_destroy       = false
    create_before_destroy = false
    # ignore_changes        = [tags]
  }
}

resource "aws_iam_instance_profile" "test_profile" {
  name       = "test"
  depends_on = [aws_instance.ec2_1]
}
