# Terraform state will be stored in S3
terraform {
  backend "s3" {
    bucket = "terraform-bucket-alex"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
#Use Aws Terraform Provider
provider "aws"{
region = "${var.aws_region}"
}
