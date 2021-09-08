resource "aws_eks_fargate_profile" "default" {
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  cluster_name                = var.eks_cluster_name
  fargate_profile_name        = local.name
  pod_execution_role_arn      = var.iam_role.arn
  subnet_ids                  = var.subnet_ids

  selector {
    namespace                 = var.namespace
    labels                    = var.labels
  }

  tags                        = local.aws_tags
}
