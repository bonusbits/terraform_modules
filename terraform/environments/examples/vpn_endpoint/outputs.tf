output security_group {
  value                     = module.security_group.security_group
  // object
}

output security_group_rules {
  value                     = module.security_group.security_group_rules
  // object
}

output vpn_endpoint {
  value                     = module.vpn_endpoint.vpn_endpoint
  // object
}
