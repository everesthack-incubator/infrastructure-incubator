resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.eh_route53_zone.zone_id
  name    = var.domain_name
  type    = "CNAME"
  ttl     = "1"
  records = [module.eh_elb.this_elb_dns_name]
  allow_overwrite = true
}