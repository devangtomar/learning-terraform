# Use of count

resource "aws_iam_user" "sample-user" {
  count = 3
  name  = "neo-${count.index}"
}

## Array lookup syntax

variable "user_names" {
  description = "Create IAM users with these name"
  type        = list(string)
  default     = ["neo", "tintin", "morpheus"]
}

# We can use modules variables as well like.. module.users[*].user_arn

resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

output "first_arn" {
  description = "The ARN for the first user"
  value       = aws_iam_user.example[0].arn
}

output "all_arn" {
  description = "The ARN for the first user"
  value       = aws_iam_user.example[*].arn
}

# Loops with for_each expressions

resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  name     = each.value
}

output "all_arn_via_loop" {
  value = values(aws_iam_user.example)[*].arn
}

# Dynamic block

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = data.aws_subnets.default.ids
  target_group_arns    = [aws_lb_target_group.asg.arn]
  health_check_type    = "ELB"
  min_size             = var.min_size
  max_size             = var.max_size
  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }
  dynamic "tag" {
    for_each = var.custom_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# Loops with expressions..

variable "hero_thousand_faces" {
  type = map(string)
  default = {
    "dev" = "developer"
    "hr"  = "Human resource"
  }
}

variable "names" {
  type    = list(string)
  default = ["abc", "def"]
}

output "upper_names" {
  value = [for name in var.names : upper(name)]
}

output "short_upper_names" {
  value = [for name in var.var.names : upper(name) if length(name) < 5]
}

output "bios" {
  value = [for name, role in var.hero_thousand_faces : "${name} is the ${role}"]
}
