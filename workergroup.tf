resource "aws_security_group" "allow_traffic_from_internet" {
  name        = "${var.owner}_elb_allow_traffic_sg"
  description = "Security group to allow all traffic from internet"
  vpc_id      = module.eh_vpc.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self = true
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self = true
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "eh_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "${var.owner}_wordpress"

  # Launch configuration
  lc_name = "${var.owner}_lc"


  image_id        = var.instance_ami
  instance_type   = var.instance_type
  recreate_asg_when_lc_changes = true
  max_instance_lifetime = 604800

  security_groups = [module.eh_vpc.default_security_group_id]
  load_balancers = [module.eh_elb.this_elb_id]
  health_check_type = "ELB"
  spot_price = "0.013"

  root_block_device = [
    {
      volume_size = "30"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "${var.owner}_asg"
  vpc_zone_identifier       = local.private_subnet_ids
  min_size                  = 1
  max_size                  = 5
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
  key_name = aws_key_pair.eh_key_pair.key_name
  user_data_base64 = base64encode(data.template_file.eh_instance_user_data.rendered)

}