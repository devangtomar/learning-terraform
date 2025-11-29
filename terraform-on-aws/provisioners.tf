resource "aws_instance" "ubuntu2204" {

  provisioner "file" {
    source      = "test-file.txt"
    destination = "/home/ubuntu/test-file.txt"
  }

  provisioner "file" {
    content     = "I want to copy this string to the destination file => server.txt (using provisioner file content)"
    destination = "/home/ubuntu/server.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo helloworld remote-exec provisioner >> hello.txt",
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("testkey.pem")
    timeout     = "4m"
  }
}

resource "null_resource" "example" {
  provisioner "local-exec" {
    command     = "'This is test file for null resource local-exec' >>  nullresource-generated.txt"
    interpreter = ["PowerShell", "-Command"]
  }
}
