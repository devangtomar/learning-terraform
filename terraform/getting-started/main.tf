terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = "~> 4.0"
    # }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2_instance" {
  ami                    = "ami-0d0bed6857ceeda4b" # AMI for Amazon linux..
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data              = <<-EOF
  #!/bin/bash
  echo 'Hello world!' > index.html
  nohup busybox httpd -f -p 8080 &
  EOF

  tags = {
    Name : "first-ec2-via-terraform"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "id" {
  description = "ID of aws security group"
  value       = aws_security_group.instance.id
  depends_on  = [aws_security_group.instance]
}

output "from_variables_tf" {
  value = var.list_example
}

resource "aws_launch_configuration" "example" {
  depends_on      = [aws_instance.ec2_instance]
  image_id        = aws_instance.ec2_instance.ami
  instance_type   = aws_instance.ec2_instance.instance_type
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
  #!/bin/bash
  echo "Hello, World" > index.html
  nohup busybox httpd -f -p ${var.server_port} &
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_example" {
  depends_on           = [aws_security_group.instance]
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = data.aws_subnets.default.ids
  min_size             = 2
  max_size             = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}