variable "aws_region" {
  default = "ap-northeast-1"
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
  default = ["ap-northeast-1a", "ap-northeast-1b"]
}
variable "webservers_ami" {
  default = "ami-0dacc1250335dab23"
}

variable "instance_type" {
  default = "t2.micro"
}
