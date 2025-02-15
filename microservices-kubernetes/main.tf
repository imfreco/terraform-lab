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
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  instance_names = {
    "msvc-users-instance"   = module.msvc-users-sg.security_group_id
    "msvc-courses-instance" = module.msvc-courses-sg.security_group_id
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = "ec2-access-manager"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/ec2-access-manager.pem"
}

resource "aws_instance" "msvc-kubernetes-instance" {
  for_each = local.instance_names

  ami                    = local.ami
  instance_type          = each.key == "msvc-users-instance" ? "t2.small" : local.instance_type
  subnet_id              = each.key == "msvc-users-instance" ? module.terraform-vpc.public_subnets[0] : module.terraform-vpc.public_subnets[1]
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [each.value]

  tags = {
    Name = each.key
  }
}