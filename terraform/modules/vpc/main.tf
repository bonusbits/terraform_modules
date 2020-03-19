resource "aws_vpc" "default" {
  cidr_block                  = var.tf_vars.vpc_cidr_block
  enable_dns_support          = var.tf_vars.enable_dns_support
  enable_dns_hostnames        = var.tf_vars.enable_dns_hostname
  tags                        = merge(local.aws_tags, {Name = local.name})
}

resource "aws_vpc_dhcp_options" "default" {
  domain_name                 = var.tf_vars.dhcp_domain_name
  domain_name_servers         = ["AmazonProvidedDNS"]
  tags                        = merge(local.aws_tags, {Name = local.name})
}

resource "aws_vpc_dhcp_options_association" "default" {
  vpc_id                      = aws_vpc.default.id
  dhcp_options_id             = aws_vpc_dhcp_options.default.id
}

# Private DNS Zone
resource "aws_route53_zone" "private" {
  name                        = var.tf_vars.dns_domain_name
  comment                     = "${terraform.workspace} - managed by terraform "
  vpc {
    vpc_id                    = aws_vpc.default.id
  }
  tags                        = merge(local.aws_tags, {Name = terraform.workspace})
}

# Internet Gateway
resource "aws_internet_gateway" "default" {
  vpc_id                      = aws_vpc.default.id
  tags                        = merge(local.aws_tags, {Name = local.name})
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id                      = aws_vpc.default.id
  service_name                = data.aws_vpc_endpoint_service.s3.service_name
  tags                        = merge(local.aws_tags, {Name = "${local.name}-s3"})
}

# Public Route Table
## make the route table separate from the first entry or it conflicts with aws_route directives
resource "aws_route_table" "public" {
  vpc_id                      = aws_vpc.default.id
  tags                        = merge(local.aws_tags, {Name = "${local.name}-public"})
}

resource "aws_vpc_endpoint_route_table_association" "public" {
  count                       = 1
  route_table_id              = aws_route_table.public.id
  vpc_endpoint_id             = aws_vpc_endpoint.s3.id
}

# default route out to the internet
resource "aws_route" "public_igw" {
  route_table_id              = aws_route_table.public.id
  destination_cidr_block      = "0.0.0.0/0"
  gateway_id                  = aws_internet_gateway.default.id
}

# Private Route Table
resource "aws_route_table" "private" {
  count                       = var.tf_vars.multi_az_nat ? local.setup_az_count : 1
  vpc_id                      = aws_vpc.default.id
  tags                        = merge(local.aws_tags, {Name = var.tf_vars.multi_az_nat ? "${local.name}-private-${element(data.aws_availability_zone.setup_azs.*.name_suffix, count.index)}" : "${local.name}-private"})
}

resource "aws_vpc_endpoint_route_table_association" "private" {
  count                       = local.setup_az_count
  route_table_id              = element(aws_route_table.private.*.id, count.index)
  vpc_endpoint_id             = aws_vpc_endpoint.s3.id
}

# Public Subnet (Public No NAT)
resource "aws_subnet" "public" {
  vpc_id                      = aws_vpc.default.id
  count                       = local.setup_az_count
  cidr_block                  = cidrsubnet(var.tf_vars.public_cidr_block, var.tf_vars.public_newbits, count.index)
  availability_zone           = element(data.aws_availability_zone.setup_azs.*.name, count.index)
//  map_public_ip_on_launch     = "true"
  tags                        = merge(
    local.aws_tags,
    {
      "kubernetes.io/cluster/${terraform.workspace}"  = "shared"
      "kubernetes.io/role/elb"  = "1"
      Name                      = "${local.name}-public-${element(data.aws_availability_zone.setup_azs.*.name_suffix, count.index)}"
    }
  )
}
resource "aws_route_table_association" "public" {
  count                       = local.setup_az_count
  subnet_id                   = element(aws_subnet.public.*.id, count.index)
  route_table_id              = aws_route_table.public.id
}

# Private
resource "aws_subnet" "private" {
  vpc_id                      = aws_vpc.default.id
  count                       = local.setup_az_count
  cidr_block                  = cidrsubnet(var.tf_vars.private_cidr_block, var.tf_vars.private_newbits, count.index)
  availability_zone           = element(data.aws_availability_zone.setup_azs.*.name, count.index)
  tags                        = merge(
    local.aws_tags,
    {
      "kubernetes.io/cluster/${terraform.workspace}"  = "shared"
      "kubernetes.io/role/internal-elb"               = "1"
      Name                      = "${local.name}-private-${element(data.aws_availability_zone.setup_azs.*.name_suffix, count.index)}"
    }
  )
}

resource "aws_route_table_association" "private" {
  count                       = local.setup_az_count
                                # Not sure why this works for if only one route_table_id
  route_table_id              = element(aws_route_table.private.*.id, count.index)
  subnet_id                   = element(aws_subnet.private.*.id, count.index)
}

//resource "aws_main_route_table_association" "private" {
//  vpc_id                      = aws_vpc.default.id
//  route_table_id              = element(aws_route_table.private.*.id, 0)
//}

# Network ACLs
resource "aws_network_acl" "private" {
  vpc_id                      = aws_vpc.default.id
  subnet_ids                  = concat(aws_subnet.private.*.id)
  tags                        = merge(local.aws_tags, {Name = "${local.name}-private"})
}

resource "aws_network_acl_rule" "private_egress_100" {
  network_acl_id              = aws_network_acl.private.id
  rule_number                 = 100
  egress                      = true
  protocol                    = "all"
  rule_action                 = "allow"
  cidr_block                  = "0.0.0.0/0"
}
resource "aws_network_acl_rule" "private_ingress_100" {
  network_acl_id              = aws_network_acl.private.id
  rule_number                 = 100
  egress                      = false
  protocol                    = "all"
  rule_action                 = "allow"
  cidr_block                  = "0.0.0.0/0"
}

resource "aws_network_acl" "public" {
  vpc_id                      = aws_vpc.default.id
  subnet_ids                  = concat(aws_subnet.public.*.id)
  tags                        = merge(local.aws_tags, {Name = "${local.name}-public"})
}

# Inbound any/any (Would break everything having this in)
//resource "aws_network_acl_rule" "public_ingress_100" {
//  network_acl_id              = aws_network_acl.public.id
//  rule_number                 = 100
//  egress                      = false
//  protocol                    = "all"
//  rule_action                 = "allow"
//  cidr_block                  = "0.0.0.0/0"
//}

# Outbound any/any
resource "aws_network_acl_rule" "public_egress_100" {
  network_acl_id              = aws_network_acl.public.id
  rule_number                 = 100
  egress                      = true
  protocol                    = "all"
  rule_action                 = "allow"
  cidr_block                  = "0.0.0.0/0"
}
# VPC public/private - any/any
resource "aws_network_acl_rule" "public_ingress_100" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 100
  egress                        = false
  protocol                      = "all"
  rule_action                   = "allow"
  cidr_block                    = var.tf_vars.vpc_cidr_block
}

# Remote Host Connections
# SSH
resource "aws_network_acl_rule" "public_ingress_200" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 200
  egress                        = false
  protocol                      = "tcp"
  rule_action                   = "allow"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 22
  to_port                       = 22
}
# RDP
resource "aws_network_acl_rule" "public_ingress_210" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 210
  egress                        = false
  protocol                      = "tcp"
  rule_action                   = "allow"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 3389
  to_port                       = 3389
}

# Web
# HTTP
resource "aws_network_acl_rule" "public_ingress_300" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 300
  egress                        = false
  protocol                      = "tcp"
  rule_action                   = "allow"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 80
  to_port                       = 80
}
# HTTPS
resource "aws_network_acl_rule" "public_ingress_310" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 310
  egress                        = false
  protocol                      = "tcp"
  rule_action                   = "allow"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 443
  to_port                       = 443
}

# VPN
# ISAKMP or IPSEC crypto
resource "aws_network_acl_rule" "public_ingress_400" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 400
  egress                        = false
  protocol                      = "udp"
  rule_action                   = "allow"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 500
  to_port                       = 500
}
# sae-urn
resource "aws_network_acl_rule" "public_ingress_410" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 410
  egress                        = false
  protocol                      = "udp"
  rule_action                   = "allow"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 4500
  to_port                       = 4500
}
# l2f,l2tp,ipsec
resource "aws_network_acl_rule" "public_ingress_420" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 420
  egress                        = false
  protocol                      = "udp"
  rule_action                   = "allow"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 1701
  to_port                       = 1701
}
# AWS Client VPN Endpoint (Alt Port)
resource "aws_network_acl_rule" "public_ingress_430" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 430
  egress                        = false
  protocol                      = "udp"
  rule_action                   = "allow"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 1194
  to_port                       = 1194
}

# Safety Deny Rules
## In case someone accidentally opens a port on public
# MS SQL - Deny
resource "aws_network_acl_rule" "public_ingress_800" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 800
  egress                        = false
  protocol                      = "tcp"
  rule_action                   = "deny"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 1433
  to_port                       = 1433
}
# Oracle SQL - Deny
resource "aws_network_acl_rule" "public_ingress_810" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 810
  egress                        = false
  protocol                      = "tcp"
  rule_action                   = "deny"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 1521
  to_port                       = 1521
}
# MySQL/Aurora - Deny
resource "aws_network_acl_rule" "public_ingress_820" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 820
  egress                        = false
  protocol                      = "tcp"
  rule_action                   = "deny"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 3306
  to_port                       = 3306
}
# NFS - Deny
resource "aws_network_acl_rule" "public_ingress_830" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 830
  egress                        = false
  protocol                      = "tcp"
  rule_action                   = "deny"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 2049
  to_port                       = 2049
}
# Postgres - Deny
resource "aws_network_acl_rule" "public_ingress_840" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 840
  egress                        = false
  protocol                      = "tcp"
  rule_action                   = "deny"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 5432
  to_port                       = 5432
}
# Alt HTTP Port - Deny
resource "aws_network_acl_rule" "public_ingress_850" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 850
  egress                        = false
  protocol                      = "tcp"
  rule_action                   = "deny"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 8080
  to_port                       = 8080
}
# Alt HTTP Port - Deny
resource "aws_network_acl_rule" "public_ingress_860" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 860
  egress                        = false
  protocol                      = "tcp"
  rule_action                   = "deny"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 8443
  to_port                       = 8443
}

# Blanket Denies
# Allow 1024-65535 TCP
resource "aws_network_acl_rule" "public_ingress_900" {
  network_acl_id                = aws_network_acl.public.id
  rule_number                   = 900
  egress                        = false
  protocol                      = "tcp"
  rule_action                   = "allow"
  cidr_block                    = "0.0.0.0/0"
  from_port                     = 1024
  to_port                       = 65535
}
# Deny any/any Last Rule (Automatically Added)
//resource "aws_network_acl_rule" "public_ingress_910" {
//  network_acl_id                = aws_network_acl.public.id
//  rule_number                   = 910
//  egress                        = false
//  protocol                      = "all"
//  rule_action                   = "deny"
//  cidr_block                    = "0.0.0.0/0"
//}
