output fargate_profiles {
  value                   = {for k, v in module.eks_fargate_profiles : k => v.fargate_profile}
  // map(object)
}

output iam_role_fargate {
  value                   = module.eks_fargate_role.iam_role
  // object
}

output k8s_namespaces {
  value                   = {for k, v in module.k8s_namespaces : k => v.namespace}
  // map(object)
}
