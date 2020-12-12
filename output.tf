output "template" {
  value = data.template_file.eh_instance_user_data.rendered
  description = "Rendered template file (used in Workergroup)"
}

output "www" {
  value = aws_route53_record.www
  description = "Route 53 record of the Wordpress deployed"
}