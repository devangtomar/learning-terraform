resource "aws_autoscaling_group" "example" {
  max_size = 3
  min_size = 1
  # Wait for at least this many instances to pass health checks before
  # considering the ASG deployment complete
  min_elb_capacity = 1

  # When replacing this ASG, create the replacement first, and only delete the
  # original after

  lifecycle {
    create_before_destroy = true
  }
}
