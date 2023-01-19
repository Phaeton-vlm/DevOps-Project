resource "aws_subnet" "subnet_backend" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "Backend subnet"
  }
}


resource "aws_security_group" "backend_security_group" {
  name = "backend_security_group"
  description = "Inbound traffic to the Backend"
  vpc_id     = aws_vpc.test_vpc.id

  dynamic "ingress" {
    for_each = "${var.backend_ports}"
    content {
      description = "Ports from Backend"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      security_groups = [ aws_security_group.frontend_security_group.id ]
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "Backend security group"
  }
}