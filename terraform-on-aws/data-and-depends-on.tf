data "aws_instance" "data_instance" {
  filter {
    name   = "tag:Name"
    values = ["Basic Instance"]
  }

  depends_on = [
    aws_instance.instance
  ]
}

output "instance_info" {
  value = data.aws_instance.data_instance
}