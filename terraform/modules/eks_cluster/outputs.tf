output cluster {
  value       = aws_eks_cluster.default
  // object
}

output "endpoint" {
  value = aws_eks_cluster.default.endpoint
  // string
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.default.certificate_authority[0].data
  // string
}

output iam_role {
  value       = aws_iam_role.default
  // object
}

output "oidc_provider" {
  value       = aws_iam_openid_connect_provider.oidc_provider
  // object
}
