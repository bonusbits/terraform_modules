data "aws_region" "current" {}
data "aws_acm_certificate" "server_cert" {
  domain                      = "server.${terraform.workspace}.vpn.bonusbits.com"
  types                       = ["IMPORTED"]
  statuses                    = ["ISSUED"]
}
data "aws_acm_certificate" "client_cert" {
  domain                      = "client.${terraform.workspace}.vpn.bonusbits.com"
  types                       = ["IMPORTED"]
  statuses                    = ["ISSUED"]
}

locals {
  aws_region                  = data.aws_region.current.name
  name                        = "${terraform.workspace}-vpn"
}

resource "aws_ec2_client_vpn_endpoint" "default" {
  description                  = terraform.workspace
  server_certificate_arn       = data.aws_acm_certificate.server_cert.arn
  client_cidr_block            = var.tf_vars.client_cidr_block
  split_tunnel                 = tobool(var.tf_vars.split_tunnel)
  dns_servers                  = var.dns_servers

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = data.aws_acm_certificate.client_cert.arn
  }

  connection_log_options {
    enabled                   = true
    cloudwatch_log_group      = var.cloudwatch_log_group.name
    #cloudwatch_log_stream     = aws_cloudwatch_log_stream.ls.name
  }

  tags                        = local.aws_tags
}

resource "aws_ec2_client_vpn_network_association" "default" {
  count                       = length(var.private_subnet_ids)
  client_vpn_endpoint_id      = aws_ec2_client_vpn_endpoint.default.id
  subnet_id                   = element(var.private_subnet_ids, count.index)
}

resource "aws_ec2_client_vpn_route" "default" {
  count                       = length(var.private_subnet_ids)
  client_vpn_endpoint_id      = aws_ec2_client_vpn_endpoint.default.id
  description                 = "Internet Access"
  destination_cidr_block      = "0.0.0.0/0"
  target_vpc_subnet_id        = element(var.private_subnet_ids, count.index)

  depends_on = [
    aws_ec2_client_vpn_endpoint.default,
    aws_ec2_client_vpn_network_association.default
  ]
}

resource "null_resource" "authorize-client-vpn-ingress" {
  provisioner "local-exec" {
    when    = create
    command = "aws --region ${local.aws_region} ec2 authorize-client-vpn-ingress --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.default.id} --target-network-cidr 0.0.0.0/0 --authorize-all-groups"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_ec2_client_vpn_endpoint.default,
    aws_ec2_client_vpn_network_association.default
  ]
}

resource null_resource "client-vpn-security-group" {
  provisioner "local-exec" {
    when    = create
    command = "aws ec2 apply-security-groups-to-client-vpn-target-network --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.default.id} --vpc-id ${var.security_group.vpc_id} --security-group-ids ${var.security_group.id}"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_ec2_client_vpn_endpoint.default
  ]
}
