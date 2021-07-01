# Monter l'infra de recette sur AWS avec Terraform

Terraform permet de créer de manière programmable une infrastructure dans le Cloud pour notre application.
Utiliser la version 0.14 de Terraform au minimum.

# Terraform - Infra as code

## Terraform backend

Ce projet utilise [Terraform S3 backend](https://www.terraform.io/docs/language/settings/backends/s3.html). Si vous souhaitez utiliser ce projet avec le backend S3 (ou non), modifier la [configuration Terraform](./terraform.tf).

## Commandes Terraform

Pour initialiser votre Terraform
```bash
terraform init
```

> Si vous avez une erreur avec le backend S3, vous pouvez retirer le block
> Backend S3 dans le fichier terraform.tf

Une fois vos fichiers Terraform complétés, pour créer votre stack
```bash
terraform plan
terraform apply
```

Et pour détruire une stack Terraform
```bash
terraform destroy
```

# Terraform project

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.47.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.47.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.back](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/resources/autoscaling_group) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/resources/eip) | resource |
| [aws_elb.front](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/resources/elb) | resource |
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/resources/internet_gateway) | resource |
| [aws_launch_template.back](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/resources/launch_template) | resource |
| [aws_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/resources/nat_gateway) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/resources/route_table_association) | resource |
| [aws_security_group.back](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/resources/security_group) | resource |
| [aws_security_group.elb](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/resources/security_group) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/resources/vpc) | resource |
| [aws_ami.amazon-linux-2](https://registry.terraform.io/providers/hashicorp/aws/3.47.0/docs/data-sources/ami) | data source |
| [template_file.init](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_back_instance_number"></a> [back\_instance\_number](#input\_back\_instance\_number) | The number of instance should be used in the autoscaling\_group. | `string` | `"2"` | no |
| <a name="input_back_instance_type"></a> [back\_instance\_type](#input\_back\_instance\_type) | The instance type you want to use for your EC2 backend. | `string` | `"t3.micro"` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The CIDR block to use for VPC. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_front_elb_port"></a> [front\_elb\_port](#input\_front\_elb\_port) | The port to allow from ELB. | `string` | `"80"` | no |
| <a name="input_front_elb_protocol"></a> [front\_elb\_protocol](#input\_front\_elb\_protocol) | The protocol to allow from ELB. | `string` | `"http"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Shared variables | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region used. | `string` | `"eu-west-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_elb_endpoint"></a> [elb\_endpoint](#output\_elb\_endpoint) | Your website endpoint through Elastic Load Balancer (ELB). |
