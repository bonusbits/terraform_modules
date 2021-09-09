eks_compute = {
  namespaces = {
    demo       = "demo"
  }
  node_groups             = {
    ami_type                    = "AL2_x86_64"
    desired_size                = "1"
    disk_size                   = "40"
    instance_type               = "t3.small"
    max_size                    = "10"
    min_size                    = "1"
  }
}
