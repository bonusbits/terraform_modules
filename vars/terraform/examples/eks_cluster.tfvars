eks_cluster = {
  kubernetes_version          = "1.21"
  enabled_cluster_log_types   = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ],
  endpoint_private_access     = "true"
  endpoint_public_access      = "true"

  node_group                    = {
    ami_type                    = "AL2_x86_64"
    desired_size                = "1"
    disk_size                   = "40"
    instance_type               = "t3.small"
    max_size                    = "10"
    min_size                    = "1"
  }
}
