network = {
  # Determines if need split private route tables per az. Plus if nat_gateway module used then how many to create.
  # Required even if not using nat
  multi_az_nat                  = false
  vpc = {
    # Setup Availability Zone Count is max number or AZs to setup.
    # If Region has less that total count will be setup. such as Canada = 2 azs
    # cidrsubnet("10.0.0.0/21", 3, 0)
    setup_az_count              = "3"
    dhcp_domain_name            = "demo.local"
    dns_domain_name             = "demo.local"
    private_newbits             = "3"
    private_cidr_block          = "10.16.16.0/21"
    # 21 + 3 = /24 =
    # ipcalc 10.0.3.0/24 = 256 az1
    # ipcalc 10.0.4.0/24 = 256 az2
    # ipcalc 10.0.5.0/24 = 256 az3
    public_newbits              = "3"
    public_cidr_block           = "10.0.0.0/21"
    # ipcalc 10.0.0.0/24 = 256 az1
    # ipcalc 10.0.1.0/24 = 256 az2
    # ipcalc 10.0.2.0/24 = 256 az3
    vpc_cidr_block              = "10.0.0.0/21"
    enable_dns_support          = true
    enable_dns_hostname         = true
  }
}
