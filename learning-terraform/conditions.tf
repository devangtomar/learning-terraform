variable "number_of_ec2_machines" {
  type = list(string)
  default = ["one", "two", "three", "four", "five"]
  description = "Name of ec2 machines that needs to be created"
}

variable "some_random_num" {
  type = number
  default = 4
}

resource "aws_instance" "adding_ec2" {
  count = length(var.number_of_ec2_machines)
  id = var.some_random_num > 6 ? "greater_than_6" : "lesser_than_6"
  for_each = var.number_of_ec2_machines
  host_id = each.value
}

resource "aws_instance" "name" {
  id = var.some_random_num > 5 ? "more" : "less"
}