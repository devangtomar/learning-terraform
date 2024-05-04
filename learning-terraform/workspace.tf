locals {
  tag = "${terraform.workspace} EC2"
}

resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = local.tag
  }
}
