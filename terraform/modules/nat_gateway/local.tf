locals {
  aws_region                    = data.aws_region.current.name
  aws_tags                      = merge(
    var.base_aws_tags,
    {
      Terraform_Module          = "nat_gateway"
    }
  )
  name                          = replace(terraform.workspace, "_", "-")
}
