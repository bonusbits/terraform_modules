output aws_load_balancer_controller {
  value           = module.eks_ingress_controller.aws_load_balancer_controller
  sensitive       = true
  // object
}

output iam_role {
  value       = module.eks_ingress_controller.iam_role
  // object
}

output iam_policy {
  value       = module.eks_ingress_controller.iam_policy
  // object
}

output kubernetes_service_account {
  value       = module.eks_ingress_controller.kubernetes_service_account
  // object
}
