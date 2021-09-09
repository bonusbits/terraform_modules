cloudwatch_logs = {
  bastion = {
    retention_in_days   = "90"
    name                = "/demo-dev-use1/ec2/bastion"
  }
  eks_cluster = {
    retention_in_days   = "90"
    name                = "/aws/eks/bb-dev-usw2/cluster"
  }
  vpn_endpoint = {
    retention_in_days   = "90"
    name                = "/aws/vpn_endpoint/demo-dev-use1"
  }
}
