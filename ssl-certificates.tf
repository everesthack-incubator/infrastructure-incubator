resource "aws_acm_certificate" "eh_certificate" {
  domain_name       = var.domain_name 
  validation_method = "DNS"

  tags = merge(local.tags, { Name = var.domain_name})
}

data "aws_route53_zone" "eh_route53_zone" {
  name         = var.route53_zone
  private_zone = false
}

resource "aws_route53_record" "eh_route53_record" {
  for_each = {
    for dvo in aws_acm_certificate.eh_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.eh_route53_zone.zone_id
}

resource "aws_acm_certificate_validation" "eh_certificate_validation" {
  certificate_arn         = aws_acm_certificate.eh_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.eh_route53_record : record.fqdn]
}