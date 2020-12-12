## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12 |
| aws | >= 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.7.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_profile | AWS Profile Name | `string` | n/a | yes |
| aws\_region | AWS Region | `string` | `"ap-southeast-1"` | no |
| azs | List of availability zones from the AWS Region | `list(string)` | <pre>[<br>  "ap-south-1a",<br>  "ap-south-1b",<br>  "ap-south-1c"<br>]</pre> | no |
| cidr | Primary CIDR block of the VPC | `string` | `"10.0.0.0/16"` | no |
| db\_create | Create AWS RDS mysql db | `bool` | `true` | no |
| db\_instance\_name | Database instance name for mysql db | `string` | n/a | yes |
| db\_instance\_type | RDS instance type | `string` | `"db.t2.micro"` | no |
| db\_name | RDS mysql database name | `string` | `"bitname_wordpress"` | no |
| db\_password | RDS password for mysql user | `string` | n/a | yes |
| db\_user | RDS mysql username | `string` | `"bn_wordpress"` | no |
| domain\_name | Domain name of the wordpress setup to be deployed (To be added to Route53 Zone) | `string` | n/a | yes |
| environment | Application deployment environment (dev/staging/prod) | `string` | `"prod"` | no |
| instance\_ami | Bitnami Wordpress AMI | `string` | n/a | yes |
| instance\_type | Workergroup instance type | `string` | `"t2.micro"` | no |
| owner | Ownership label | `string` | `"eh"` | no |
| private\_subnets | List of private subnets (derived from primary CIDR) | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| public\_key | SSH public key to be added to ~/.ssh/authorized\_keys | `string` | n/a | yes |
| public\_subnets | List of public subnets (derived from primary CIDR) | `list(string)` | <pre>[<br>  "10.0.101.0/24",<br>  "10.0.102.0/24",<br>  "10.0.103.0/24"<br>]</pre> | no |
| route53\_zone | Route53 zone | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| template | Rendered template file (used in Workergroup) |
| www | Route 53 record of the Wordpress deployed |

