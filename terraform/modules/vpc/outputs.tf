output set_availability_zones {
  value         = data.aws_availability_zone.setup_azs.*.name
  // object
}

output set_availability_zones_count {
  value         = local.setup_az_count
  // object
}

output region {
  value         = local.aws_region
  // object
}

output zone_id_prefix {
  value         = local.zone_id_prefix
  // string
}

output dns_zone_private {
  value        = aws_route53_zone.private
  // object
}

output dns_zone_private_name {
  value         = aws_route53_zone.private.name
  // string
}

output network_acls {
  value         = {
    public      = aws_network_acl.public.*,
    private     = aws_network_acl.private.*,
  }
  // map(list(object))
}

output internet_gateway {
  value         = aws_internet_gateway.default
  // object
}

output route_tables {
  value         = {
    private     = aws_route_table.private,
    public      = aws_route_table.public
  }
  // map(object)
}

output subnets {
  value         = {
    public      = aws_subnet.public.*,
    private     = aws_subnet.private.*,
  }
  // map(list(object))
}

output subnet_ids {
  value         = {
    public      = aws_subnet.public.*.id,
    private     = aws_subnet.private.*.id,
  }
  // map(list(string))
}

output vpc {
  value         = aws_vpc.default
  // object
}

output vpc_dhcp_options {
  value         = aws_vpc_dhcp_options.default
  // object
}

output vpc_endpoint_s3 {
  value         = aws_vpc_endpoint.s3
  // object
}
