# IAM Role for EKS Cluster
resource "aws_iam_role" "default" {
  name                        = "${local.name}-eks-cluster"
  assume_role_policy          = file("${path.module}/files/iam_role_policy.json")

  tags                        = merge(local.aws_tags, {Name = "${local.name}-eks-cluster"})
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn                  = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role                        = aws_iam_role.default.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  policy_arn                  = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role                        = aws_iam_role.default.name
}

resource "aws_eks_cluster" "default" {
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller,
  ]
  name                        = local.name
  role_arn                    = aws_iam_role.default.arn
  enabled_cluster_log_types   = var.tf_vars.enabled_cluster_log_types
  version                     = var.tf_vars.kubernetes_version

  vpc_config {
    endpoint_private_access   = tobool(var.tf_vars.endpoint_private_access)
    endpoint_public_access    = tobool(var.tf_vars.endpoint_public_access)
    public_access_cidrs       = var.public_access_cidrs
    security_group_ids        = null
    subnet_ids                = var.subnet_ids
  }

  tags                        = merge(local.aws_tags, {Name = local.name})
}

# Add IAM Identity Provider OIDC (OpenID Connect)
# https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider
# Way to bridge IAM Authentication into Kubernetes Service (EKS cluster). So Kubernetes can create/manager AWS Load Balancers (ALB/NLB) from the Ingress Controller service. RBAC
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list              = [local.sts_principal]
//  thumbprint_list             = [data.external.thumbprint.result.thumbprint]
  thumbprint_list             = [data.tls_certificate.oidc_thumbprint.certificates.0.sha1_fingerprint]
  url                         = aws_eks_cluster.default.identity.0.oidc.0.issuer

  tags                        = merge(local.aws_tags, {Name = "${terraform.workspace}-eks-iam-auth"})
}
