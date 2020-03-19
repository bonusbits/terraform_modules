network = {
  # Determines if need split private route tables per az. Plus if nat_gateway module used then how many to create.
  # Required even if not using nat
  multi_az_nat                  = false
  vpc = {
    # Setup Availability Zone Count is max number or AZs to setup.
    # If Region has less that total count will be setup. such as Canada = 2 azs
    setup_az_count              = "3"
    dhcp_domain_name            = "bonusbits.local"
    dns_domain_name             = "bonusbits.local"
    private_newbits             = "3"
    private_cidr_block          = "10.60.64.0/18" # 2nd 1/4 of /16
    # ipcalc 10.60.64.0/21 = 2046 az1
    # ipcalc 10.60.72.0/21 = 2046 az2
    # ipcalc 10.60.80.0/21 = 2046 az3
    # ipcalc 10.60.88.0/21 = 2046 az4
    # ipcalc 10.60.96.0/21 = 2046 az5
    # ipcalc 10.60.102.0/21 = 2046 az6
    public_newbits              = "3"
    public_cidr_block           = "10.60.0.0/18" # 1st 1/4 of /16
    # ipcalc 10.60.0.0/21 = 2046 az1
    # ipcalc 10.60.8.0/21 = 2046 az2
    # ipcalc 10.60.16.0/21 = 2046 az3
    # ipcalc 10.60.24.0/21 = 2046 az4
    # ipcalc 10.60.32.0/21 = 2046 az5
    # ipcalc 10.60.40.0/21 = 2046 az6
    vpc_cidr_block              = "10.60.0.0/16"
    # ipcalc 10.60.0.0/18 = 16382
    # ipcalc 10.60.0.0/16 = 65534
    enable_dns_support          = true
    enable_dns_hostname         = true
  }
}
