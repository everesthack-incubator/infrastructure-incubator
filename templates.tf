data "template_file" "eh_instance_user_data" {
  template = file("${path.module}/user_data.tpl")
  vars = {
    config_file = "/opt/bitnami/apps/wordpress/htdocs/wp-config.php"
    db_password = var.db_password
    db_host = module.eh_db.this_db_instance_endpoint
    db_user = module.eh_db.this_db_instance_username
    db_name = var.db_name
    wp_config_dir = "/opt/bitnami/apps/wordpress/htdocs/wp-content"
    efs_domain = aws_efs_file_system.eh_efs.dns_name
  }
}