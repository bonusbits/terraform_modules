locals {
  aws_tags                        = merge(
    var.base_aws_tags,
    {
      Name                      = "${local.name}-eks-fargate-profile"
      Terraform_Module          = "eks_fargate_role"
    }
  )
  name                        = terraform.workspace
  name_hyphens                = replace(terraform.workspace, "_", "-")
}
