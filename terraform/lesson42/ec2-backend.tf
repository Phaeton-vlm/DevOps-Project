resource "aws_instance" "ec2_backend" {
  count = "2"
  ami = data.aws_ami.amazon_linux.id
  instance_type = "${var.ec2_instance_type}"
  key_name = "${var.key_name_ec2_backend}"
  subnet_id = aws_subnet.subnet_backend.id
  vpc_security_group_ids = [ aws_security_group.backend_security_group.id ]

  tags = {
    Name = "Backend instance"
  }
}