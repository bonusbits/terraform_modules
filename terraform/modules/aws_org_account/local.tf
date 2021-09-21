locals {
  aws_tags                      = merge(
    var.base_aws_tags,
    {
      Name                      = var.name
      Terraform_Module          = "aws_org_account"
    }
  )
}
