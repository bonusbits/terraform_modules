locals {
  aws_tags                      = merge(
    var.base_aws_tags,
    {
      Name                      = local.name
      Terraform_Module          = "eks_fargate_profile"
    }
  )
  name                          = "${terraform.workspace}-${var.name}"
  name_hyphens                  = replace(terraform.workspace, "_", "-")
}
