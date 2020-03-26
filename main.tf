# Terraform state will be stored in S3
terraform {
  backend "s3" {
    bucket = "terraform-bucket-lokesh"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
  }
}
#Use Aws Terraform Provider
provider "aws"{
region = "${var.aws_region}"
}
