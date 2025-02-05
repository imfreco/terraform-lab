terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 3.0"
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
  for_each = var.instance_names

  ami           = local.ami
  instance_type = local.instance_type
  tags = {
    Name = "EC2-${each.key}"
  }
}

resource "aws_cloudwatch_log_group" "ec2_log_group" {
  for_each = var.instance_names
  tags = {
    Environment = "test"
    Service     = each.key
  }
  lifecycle {
    create_before_destroy = true
  }
}