network = {
  # Determines if need split private route tables per az. Plus if nat_gateway module used then how many to create.
  # Required even if not using nat
  multi_az_nat                  = false
  vpc = {
    # Setup Availability Zone Count is max number or AZs to setup.
    # If Region has less that total count will be setup. such as Canada = 2 azs
    # cidrsubnet("172.16.0.0/20", 3, 0)
    setup_az_count              = "3"
    dhcp_domain_name            = "bonusbits.local"
    dns_domain_name             = "bonusbits.local"
    private_newbits             = "3"
    private_cidr_block          = "172.16.16.0/20"
    # 20 + 3 = /23 = "172.16.0.0/23","172.16.2.0/23","172.16.4.0/23"
    # ipcalc 172.16.16.0/23 = 510 az1
    # ipcalc 172.16.18.0/23 = 510 az2
    public_newbits              = "3"
    public_cidr_block           = "172.16.0.0/20"
    # ipcalc 172.16.0.0/23 = 510 az1
    # ipcalc 172.16.2.0/23 = 510 az2
    vpc_cidr_block              = "172.16.0.0/16"
    enable_dns_support          = true
    enable_dns_hostname         = true
  }
}
