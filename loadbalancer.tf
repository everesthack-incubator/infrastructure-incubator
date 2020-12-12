module "eh_elb" {
  source = "terraform-aws-modules/elb/aws"

  name = "elb-${var.owner}-${var.environment}"

  subnets         = local.public_subnet_ids
  security_groups = [aws_security_group.allow_traffic_from_internet.id]
  internal        = false

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "443"
      lb_protocol       = "HTTPS"
      ssl_certificate_id = aws_acm_certificate.eh_certificate.id
    },
 ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
  }
  tags = local.tags
}