variable "usernames" {
  type        = list(string)
  description = "IAM username"
  default     = ["user1", "user2", "user3", "user4"]
}

resource "aws_iam_user" "user_example" {
  count = length(var.usernames)
  name  = var.usernames[count.index]
}

resource "aws_iam_user" "more_user_example" {
  for_each = var.usernames
  name     = each.value
}

output "print_the_names" {
  value = [for name in var.var.usernames : name]
}