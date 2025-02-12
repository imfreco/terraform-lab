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

module "terraform-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "msvc-kubernetes-sg"
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
      from_port   = 8002
      to_port     = 8002
      protocol    = "tcp"
      description = "access to port 8002 for courses microservice"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["https-443-tcp"]
}