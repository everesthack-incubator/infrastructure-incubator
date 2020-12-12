locals {
  private_subnet_ids = [element(split("/", element(module.eh_vpc.private_subnet_arns ,0)),1), element(split("/", element(module.eh_vpc.private_subnet_arns ,1)),1), element(split("/", element(module.eh_vpc.private_subnet_arns ,2)),1) ]
  public_subnet_ids = [element(split("/", element(module.eh_vpc.public_subnet_arns ,0)),1), element(split("/", element(module.eh_vpc.public_subnet_arns ,1)),1), element(split("/", element(module.eh_vpc.public_subnet_arns ,2)),1) ]
}
resource "aws_security_group" "eh_db_sg" {
  name        = "rds-${var.db_name}"
  description = "rds sg for ${var.owner}"
  vpc_id      = module.eh_vpc.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = flatten([module.eh_vpc.private_subnets_cidr_blocks])
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

module "eh_db" {
  create_db_instance        = var.db_create
  create_db_option_group    = var.db_create
  create_db_parameter_group = var.db_create
  create_db_subnet_group    = var.db_create

  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "mysql-${var.db_instance_name}"

  engine            = "mysql"
  engine_version    = "8.0.16"
  family = "mysql8.0"
  major_engine_version = "8.0"
  instance_class     = var.db_instance_type
  allocated_storage  = 10
  storage_encrypted  = false
  multi_az           = false
  apply_immediately  = true
  ca_cert_identifier = "rds-ca-2019"

  name     = var.db_name
  username =  var.db_user
  password = var.db_password
  port     = "3306"

  vpc_security_group_ids = [aws_security_group.eh_db_sg.id, module.eh_vpc.default_security_group_id ]

  maintenance_window = "Sat:00:00-Sat:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 30

  subnet_ids = local.private_subnet_ids

  final_snapshot_identifier = "mysql-${var.db_instance_name}"

  tags = local.tags
}

