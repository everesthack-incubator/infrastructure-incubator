module "eh_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> v2.0"
  name = "${var.owner}_vpc"
  cidr = var.cidr
  azs = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = local.tags
}