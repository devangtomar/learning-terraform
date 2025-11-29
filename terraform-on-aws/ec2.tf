data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Only official Amazon images
}

resource "aws_instance" "instance_created_via_terraform" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro" # free tier eligible

  tags = {
    Name = "Free Tier Amazon Linux 2023 Instance"
  }
}
