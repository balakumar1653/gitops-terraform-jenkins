variable "aws_region" {
  default = "ap-southeast-2"
}
variable "vpc_cidr" {
  default = "10.20.0.0/16"
}

variable "subnet_cidr" {
  type    = "list"
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}
variable "avlzone" {
  type    = "list"
  default = ["ap-southeast-2a", "ap-southeast-2b"]
}
variable "webservers_ami" {
  default = "ami-038acccf3cc2c0669"
}

variable "instance_type" {
  default = "t2.micro"
}
