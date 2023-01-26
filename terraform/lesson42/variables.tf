variable "frontend_ports" {
  type = list
  default = [ "22", "80", "443" ]
}

variable "backend_ports" {
  type = list
  default = [ "22", "8080" ]
}

variable "ec2_instance_type" {
  type = string
  default = "t2.micro"
}

variable "key_name_ec2_frontend" {
  type = string
  default = "test_frontend"
}

variable "key_name_ec2_backend" {
  type = string
  default = "test_backend"
}