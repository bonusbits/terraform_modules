output eks_cluster {
  value                   = module.eks_cluster.cluster
  // object
}

output "endpoint" {
  value                   = module.eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value                   = module.eks_cluster.kubeconfig-certificate-authority-data
}

output "oidc_provider" {
  value                   = module.eks_cluster.oidc_provider
  // object
}

output iam_role_node_group {
  value                   = module.eks_node_group.iam_role
  // object
}

output key_pair {
  value                   = module.key_pair.key_pair
  // object
}

output node_group {
  value                   = module.eks_node_group.node_group
  // object
}

output security_group {
  value                   = module.security_group.security_group
  // object
}

output security_group_rules {
  value                   = module.security_group.security_group_rules
  // object
}
