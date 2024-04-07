# if statement with the count parameter

variable "enable_autoscaling" {
  type    = bool
  default = false
}

variable "cluster_name" {
  type    = string
  default = "dev"
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  count                  = var.enable_autoscaling ? 1 : 0
  scheduled_action_name  = "${var.cluster_name}-scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 9 * * *"
  autoscaling_group_name = aws_autoscaling_group.example.name
}

# If-else-statements with the count parameter

variable "give_neo_cloudwatch_full_access" {
  type    = bool
  default = true
}

output "neo_cloudwatch_policy_arn" {
  value = (
    var.give_neo_cloudwatch_full_access
    ? aws_iam_user_policy_attachment.neo_cloudwatch_full_access[0].policy_arn
    : aws_iam_user_policy_attachment.neo_cloudwatch_read_only[0].policy_arn
  )
}

# Conditionals with for_each and for Expressions

dynamic "tag" {
  for_each = {
    for key, value in var.custom_tags :
    key => upper(value)
    if key != "Name"
  }
  content {
    key                 = tag.key
    value               = tag.value
    propagate_at_launch = true
  }
}
