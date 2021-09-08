data "aws_partition" "current" {}

data "aws_region" "current" {}

data "tls_certificate" "oidc_thumbprint" {
  url = aws_eks_cluster.default.identity.0.oidc.0.issuer
}

