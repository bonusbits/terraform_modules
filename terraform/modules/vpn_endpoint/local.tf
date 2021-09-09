locals {
  aws_tags                      = merge(
    var.base_aws_tags,
    {
      Name                      = terraform.workspace
      Terraform_Module          = "vpn_endpoint"
    }
  )
}
