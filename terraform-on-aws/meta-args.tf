# Cleaned IAM resources (no duplicates). Uses for_each over a set of usernames
# to create users and attach them to groups based on name suffixes (admin, dev).

variable "user_names" {
  description = "IAM usernames"
  type        = set(string)
  default     = ["username1_admin_dev", "username2_admin", "username3_dev_s3"]
}

#####################################################
# Groups
resource "aws_iam_group" "admin_group" {
  name = "admin_group"
}

resource "aws_iam_group" "dev_group" {
  name = "dev_group"
}

#####################################################
# Policies
data "aws_iam_policy_document" "admin_policy" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "admin_policy" {
  name        = "admin-policy"
  description = "Admin policy"
  policy      = data.aws_iam_policy_document.admin_policy.json
}

data "aws_iam_policy_document" "ec2_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2-policy"
  description = "EC2 policy"
  policy      = data.aws_iam_policy_document.ec2_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::mybucket",
      "arn:aws:s3:::mybucket/*"
    ]
  }
}
resource "aws_iam_policy" "s3_policy" {
  name        = "s3-policy"
  description = "S3 policy"
  policy      = data.aws_iam_policy_document.s3_policy.json
}

#####################################################
# Attach policies to groups
resource "aws_iam_group_policy_attachment" "admin_group_admin_policy_attach" {
  group      = aws_iam_group.admin_group.name
  policy_arn = aws_iam_policy.admin_policy.arn
}

resource "aws_iam_group_policy_attachment" "dev_group_ec2_policy_attach" {
  group      = aws_iam_group.dev_group.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_group_policy_attachment" "dev_group_s3_policy_attach" {
  group      = aws_iam_group.dev_group.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

#####################################################
# Users (for_each over the set)
resource "aws_iam_user" "user" {
  for_each = var.user_names
  name     = each.key
}

# Attach users to groups based on their name tokens:
# include "admin" -> admin_group, include "dev" -> dev_group
resource "aws_iam_user_group_membership" "user_group_attach" {
  for_each = var.user_names

  user = aws_iam_user.user[each.key].name

  groups = compact([
    contains(split("_", each.key), "admin") ? aws_iam_group.admin_group.name : null,
    contains(split("_", each.key), "dev") ? aws_iam_group.dev_group.name : null,
  ])
}

#####################################################
# Output
output "print_the_names" {
  value = tolist(var.user_names)
}


# With for_each
resource "aws_iam_user" "example" {
  for_each = var.user_names_more
  name     = each.value
}
# With Map
variable "user_names_more" {
  description = "map"
  type        = map(string)
  default = {
    user1 = "username1"
    user2 = "username2"
    user3 = "username3"
  }
}
# with for loop on map 
output "user_with_roles" {
  value = [for name, role in var.user_names_more : "${name} is the ${role}"]
}