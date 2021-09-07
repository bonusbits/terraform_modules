output dns_zone_private {
  value                     = module.vpc.dns_zone_private
  // object
}

output nat_eip {
  value                     = module.nat_gateway.nat_eip
  // object
}

output nat_public_ip {
  value                     = module.nat_gateway.nat_public_ip
  // string
}

output nat_gateway {
  value                     = module.nat_gateway.nat_gateway
  // object
}

output network_acls {
  value                     = module.vpc.network_acls
  // object
}

output internet_gateway {
  value                     = module.vpc.internet_gateway
  // object
}

output region {
  value                     = module.vpc.region
  // object
}

output route_tables {
  value                     = module.vpc.route_tables
  // map(object)
}

output set_availability_zones {
  value                     = module.vpc.set_availability_zones
}

output set_availability_zones_count {
  value                     = module.vpc.set_availability_zones_count
  // object
}

output subnets {
  value                     = module.vpc.subnets
  // map(object)
}

output subnet_ids {
  value                     = module.vpc.subnet_ids
  // map(list(string))
}

output vpc {
  value                     = module.vpc.vpc
  // object
}

output vpc_dhcp_options {
  value                     = module.vpc.vpc_dhcp_options
  // object
}

output vpc_endpoint_s3 {
  value                     = module.vpc.vpc_endpoint_s3
  // object
}

output zone_id_prefix {
  value                     = module.vpc.zone_id_prefix
  // string
}
