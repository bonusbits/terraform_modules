resource "aws_iam_role" "default" {
  name                        = "${local.name}-eks-fargate-profile"
  assume_role_policy          = file("${path.module}/files/iam_role_policy.json")
  tags                        = local.aws_tags
}

resource "aws_iam_role_policy_attachment" "eks_fargate_pod_execution_role_policy" {
  policy_arn                  = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role                        = aws_iam_role.default.name
}
