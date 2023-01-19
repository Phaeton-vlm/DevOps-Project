resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"

   tags = {
    Name = "Test VPC"
  }
}


resource "aws_subnet" "frontend_subnet" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Frontent subnet"
  }
}


resource "aws_security_group" "frontend_security_group" {
  name = "frontend_security_group"
  description = "Inbound traffic to the Frontend"
  vpc_id     = aws_vpc.test_vpc.id

  dynamic "ingress" {
    for_each = "${var.frontend_ports}"
    content {
      description      = "Ports from Internet"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "Frontent security group"
  }
}