terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "-------"
  secret_key = "-------"
}

resource "aws_instance" "demo_instance" {
  ami           = "ami-011899242bb902164"
  instance_type = "t2.micro"
}