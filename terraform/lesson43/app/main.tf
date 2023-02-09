data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "../network/terraform.tfstate"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_instance" "front_ip" {
  filter {
    name   = "tag:Name"
    values = ["web instance"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [
    aws_instance.web
  ]
}

data "aws_instance" "back_ip" {
  filter {
    name   = "tag:Name"
    values = ["back instance"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [
    aws_instance.back
  ]
}

resource "aws_security_group" "vlm_sg_front" {
  name        = "vlm_sg_front"
  description = "Allow 22, 80, 443 inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  dynamic "ingress" {
    for_each = var.frontend_ports
    content {
      description = "Ports from Internet"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vlm_sg_front"
  }
}

resource "aws_security_group" "vlm_sg_back" {
  name        = "vlm_sg_back"
  description = "Allow 22, 8080 inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  dynamic "ingress" {
    for_each = var.backend_ports
    content {
      description     = "Ports from web"
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.vlm_sg_front.id]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vlm_sg_back"
  }
}

resource "aws_security_group" "vlm_sg_db" {
  name        = "vlm_sg_db"
  description = "Allow 22 inbound traffic from front, 5432 inbound traffic from back"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description     = "Port from web"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.vlm_sg_front.id]
  }

  ingress {
    description     = "Port from back"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.vlm_sg_back.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vlm_sg_db"
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = var.ec2_key_pair
  instance_type               = var.ec2_web_instance_type
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnets[0]
  security_groups             = [aws_security_group.vlm_sg_front.id]
  associate_public_ip_address = true

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("E:/vlm-key.pem")
    host     = self.public_ip
  }

  provisioner "file" {
    source      = "nginx_conf_front"
    destination = "/home/ubuntu/default"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "sudo mv /home/ubuntu/default /etc/nginx/sites-available/default",
      "sudo systemctl restart nginx",
    ]
  }


  tags = {
    Name = "web instance"
  }
}

resource "aws_instance" "back" {
  ami             = data.aws_ami.ubuntu.id
  key_name        = var.ec2_key_pair
  instance_type   = var.ec2_back_instance_type
  subnet_id       = data.terraform_remote_state.network.outputs.private_subnets[0]
  security_groups = [aws_security_group.vlm_sg_back.id]
  depends_on = [
    aws_instance.web
  ]

  connection {
    type     = "ssh"
    bastion_host = data.aws_instance.front_ip.public_ip
    bastion_user = "ubuntu"
    bastion_private_key = file("E:/vlm-key.pem")
    user     = "ubuntu"
    private_key = file("E:/vlm-key.pem")
    host     = self.private_ip
  }

  provisioner "file" {
    source      = "nginx_conf_back"
    destination = "/home/ubuntu/default"
  }

  provisioner "file" {
    source      = "index.html"
    destination = "/home/ubuntu/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "sudo mv /home/ubuntu/default /etc/nginx/sites-available/default",
      "sudo mv /home/ubuntu/index.html /var/www/html/index.html",
      "sudo systemctl restart nginx",
    ]
  }


  tags = {
    Name = "back instance"
  }
}

resource "aws_instance" "db" {
  ami             = data.aws_ami.ubuntu.id
  key_name        = var.ec2_key_pair
  instance_type   = var.ec2_back_instance_type
  subnet_id       = data.terraform_remote_state.network.outputs.db_subnets[0]
  security_groups = [aws_security_group.vlm_sg_db.id]



  tags = {
    Name = "db instance"
  }
}
