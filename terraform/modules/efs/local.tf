locals {
  aws_tags                      = merge(
    var.base_aws_tags,
    {
      Name                      = "${local.name_hyphens}-${var.name_suffix}"
      Terraform_Module          = "efs"
    }
  )
}
