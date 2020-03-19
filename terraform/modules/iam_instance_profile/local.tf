locals {
  aws_tags                      = merge(
    var.base_aws_tags,
    {
      Name                      = local.name_hyphens
      Terraform_Module          = "iam_instance_profile"
    }
  )
  name_hyphens                = replace(var.name, "_", "-")
}
