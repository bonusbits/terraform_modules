network = {
  multi_az_nat                  = false
  vpc = {
    setup_az_count              = "3"
    dhcp_domain_name            = "bonusbits.local"
    dns_domain_name             = "bonusbits.local"
    private_newbits             = "3"
    private_cidr_block          = "10.60.64.0/18"
    public_newbits              = "3"
    public_cidr_block           = "10.60.0.0/18"
    vpc_cidr_block              = "10.60.0.0/16"
    enable_dns_support          = true
    enable_dns_hostname         = true
  }
}
