resource "aws_instance" "instance_1" {
  instance_type = aws_instance.ec2_1.instance_type
  ami           = aws_instance.ec2_1.ami
  provisioner "file" {
    source      = "./data.tf"
    destination = "/home/ubuntu/data.tf"
  }
  provisioner "file" {
    content     = "I want to copy this string to the destination"
    destination = "/home/ubuntu/test.txt"
  }
  provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo helloworld remote-exec provisioner >> hello.txt",
    ]
  }
}

resource "null_resource" "example" {
  provisioner "local-exec" {
    command     = "'This is test file for null resource local-exec' >>  nullresource-generated.txt"
    interpreter = ["PowerShell", "-Command"]
  }
}
