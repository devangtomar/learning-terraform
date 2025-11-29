locals {
  ingress_rules = [{
    port        = 22
    description = "Ingress rules for port SSH"
    },
    {
      port        = 80
      description = "Ingress rules for port HTTP"
    },
    {
      port        = 443
      description = "Ingress rules for port HTTPS"
  }]
}

resource "aws_security_group" "main" {
  name = "dynamic-sg"
  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
