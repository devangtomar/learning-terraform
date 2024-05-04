locals {
  ingress_rules = [{
    port        = 22
    description = "Ingress rule for port SSH"
    }, {
    port        = 80
    description = "Ingress rule for port HTTP"
    }, {
    port        = 443
    description = "Ingress rule for port HTTPS"
    },
  ]
}

resource "aws_security_group" "main" {
  name        = "resource_with_dynamic_block"
  description = "Allow SSH inbound connections"
  vpc_id      = aws_vpc.my_vpc.id
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
