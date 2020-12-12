data "aws_ami" "amazon_linux_2" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_security_group" "allow_ssh_from_internet" {
  name        = "${var.owner}_bastion_sg"
  description = "Security group to allow ssh traffic from internet"
  vpc_id      = module.eh_vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

module "eh_bastion_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "${var.owner}_bastion"

  # Launch configuration
  lc_name = "${var.owner}_bastion_lc"

  image_id        = data.aws_ami.amazon_linux_2.id
  instance_type   = "t2.micro"

  security_groups = [module.eh_vpc.default_security_group_id, aws_security_group.allow_ssh_from_internet.id]

  root_block_device = [
    {
      volume_size = "30"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "${var.owner}_bastion_asg"
  vpc_zone_identifier       = local.public_subnet_ids
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  key_name = aws_key_pair.eh_key_pair.key_name
  spot_price = "0.013"
  recreate_asg_when_lc_changes = true

}