module "terraform-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "msvc-kubernetes-vpc"
  cidr = "10.0.0.0/16"

  azs                     = ["us-east-1a", "us-east-1b"]
  public_subnets          = ["10.0.101.0/24", "10.0.102.0/24"]
  map_public_ip_on_launch = true

  enable_vpn_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = module.terraform-vpc.public_route_table_ids[0]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.terraform-vpc.igw_id
}

module "msvc-users-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "msvc-users-sg"
  vpc_id = module.terraform-vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "access to machine through ssh client"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8001
      to_port     = 8001
      protocol    = "tcp"
      description = "access to port 8001 for users microservice"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8001
      to_port     = 8001
      protocol    = "tcp"
      description = "allow communication between vpc"
      cidr_blocks = module.terraform-vpc.vpc_cidr_block
    }
  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["https-443-tcp"]
}

module "msvc-courses-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "msvc-courses-sg"
  vpc_id = module.terraform-vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "access to machine through ssh client"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8002
      to_port     = 8002
      protocol    = "tcp"
      description = "access to port 8002 for courses microservice"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8002
      to_port     = 8002
      protocol    = "tcp"
      description = "allow communication between vpc"
      cidr_blocks = module.terraform-vpc.vpc_cidr_block
    }
  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["https-443-tcp"]
}