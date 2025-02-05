terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

locals {
  ami           = "ami-011899242bb902164"
  instance_type = "t2.micro"
}

resource "aws_instance" "demo_instance" {
  ami           = local.ami
  instance_type = local.instance_type
}