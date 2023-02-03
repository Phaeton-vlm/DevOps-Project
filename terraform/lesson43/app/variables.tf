variable "ec2_web_instance_type" {
  type = string
  default = "t2.micro"
}

variable "ec2_back_instance_type" {
  type = string
  default = "t2.micro"
}

variable "ec2_key_pair" {
  type = string
  default = "vlm-key"
}

variable "frontend_ports" {
  type = list
  default = [ "22", "80", "443" ]
}

variable "backend_ports" {
  type = list
  default = [ "22", "8080"]
}