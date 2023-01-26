resource "aws_efs_file_system" "eh_efs" {
  creation_token = "${var.owner}_efs"

  encrypted = true
}

resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.eh_efs.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "Policy",
    "Statement": [
        {
            "Sid": "Statement",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "elasticfilesystem:ClientRootAccess",
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientWrite"
            ]
        }
    ]
}
EOF
}

resource "aws_efs_mount_target" "efs_target" {
  count = length(local.private_subnet_ids)
  file_system_id = aws_efs_file_system.eh_efs.id
  subnet_id      = local.private_subnet_ids[count.index]
}
