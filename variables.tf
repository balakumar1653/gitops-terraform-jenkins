variable "instance_count" {
  default = 1
}

variable "key_name" {
  description = "Private key name to use with instance"
  default     = "JenkinsDemoSydney"
}

variable "instance_type" {
  description = "AWS instance type"
  default     = "t3.medium"
}

variable "ami" {
  description = "Base AMI to launch the instances"

  # Bitnami Lamp AMI
  default = "ami-038acccf3cc2c0669"
}
