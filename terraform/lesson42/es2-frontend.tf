data "aws_ami" "amazon_linux" {
  owners = [ "137112412989" ]
  most_recent = true
  filter {
    name = "name"
    values = [ "amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2" ]
  }
}


resource "aws_instance" "ec2_frontend" {

  ami = data.aws_ami.amazon_linux.id
  instance_type = "${var.ec2_instance_type}"
  key_name = "${var.key_name_ec2_frontend}"
  subnet_id = aws_subnet.frontend_subnet.id
  vpc_security_group_ids = [ aws_security_group.frontend_security_group.id ]

  tags = {
    Name = "Fronent instance"
  }
}