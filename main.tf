#-------------- Provider AWS ---------------------
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  version = ">= 2.7.0"
}

#-------------- AWS Key Pairs ---------------------
resource "aws_key_pair" "eh_key_pair" {
  key_name   = "eh_key"
  public_key = var.public_key
}


#-------------- Terraform Backend ---------------------
terraform {
  backend "s3" {
  }
}

locals {
  tags = {
    Environment = var.environment
    Owner   = var.owner
  } 
}