cloudwatch_logs = {
  bastion = {
    retention_in_days   = "90"
    name                = "/bb-dev-usw2/ec2/bastion"
  }
  eks_cluster = {
    retention_in_days   = "90"
    name                = "/aws/eks/bb-dev-usw2/cluster"
  }
}
