output aws_load_balancer_controller {
  value       = helm_release.aws_load_balancer_controller
  // object
}

output iam_role {
  value       = aws_iam_role.service_account
  // object
}

output iam_policy {
  value       = aws_iam_policy.service_account
  // object
}

output kubernetes_service_account {
  value       = module.k8s_service_account
  // object
}
