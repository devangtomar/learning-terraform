
# output single values
output "public_ip" {
  value = aws_instance.ec2_example.public_ip
}

# output single values
output "public_dns" {
  value = aws_instance.ec2_example.public_dns
}

# output multiple values
output "instance_ips" {
  value = {
    public_ip  = aws_instance.ec2_example.public_ip
    private_ip = aws_instance.ec2_example.private_ip
  }
}
