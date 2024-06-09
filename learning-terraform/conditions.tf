variable "some_random_num" {
  type = number
  default = 4
}

resource "aws_instance" "name" {
  id = var.some_random_num > 5 ? "more" : "less"
}