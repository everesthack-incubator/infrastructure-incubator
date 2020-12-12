variable "aws_region" {
  type = string
  default = "ap-southeast-1"
  description = "AWS Region"
}
variable "aws_profile" {
  type = string
  description = "AWS Profile Name"
}

variable "cidr" {
  type= string
  default = "10.0.0.0/16"
  description = "Primary CIDR block of the VPC"
}
variable "private_subnets" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "List of private subnets (derived from primary CIDR)"
}
variable "public_subnets" {
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  description = "List of public subnets (derived from primary CIDR)"
}
variable "db_create" {
  type = bool
  default = true
  description = "Create AWS RDS mysql db"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
  description = "Workergroup instance type"
}

variable "instance_ami" {
  type = string
  description = "Bitnami Wordpress AMI"
}

variable "db_name" {
  type = string
  default = "bitname_wordpress"
  description = "RDS mysql database name"
}

variable "db_user" {
  type = string
  default = "bn_wordpress"
  description = "RDS mysql username"
}
variable "db_password" {
  type = string
  description = "RDS password for mysql user"
}

variable "db_instance_type" {
  type = string
  default = "db.t2.micro"
  description = "RDS instance type"
}
variable "public_key" {
  type = string
  description = "SSH public key to be added to ~/.ssh/authorized_keys"
}

variable "azs" {
  type = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  description = "List of availability zones from the AWS Region"
}

variable "db_instance_name" {
  type = string
  description = "Database instance name for mysql db"
}

variable "route53_zone" {
  type = string
  description = "Route53 zone"
}

variable "domain_name" {
  type = string
  description = "Domain name of the wordpress setup to be deployed (To be added to Route53 Zone)"
}

variable "environment" {
  type = string
  default = "prod"
  description = "Application deployment environment (dev/staging/prod)"
}

variable "owner" {
  type = string
  default = "eh"
  description = "Ownership label"
}