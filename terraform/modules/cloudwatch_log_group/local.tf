locals {
  aws_tags                      = merge(
    var.base_aws_tags,
    {
      Name                      = var.name
      Terraform_Module          = "cloudwatch_log_group"
    }
  )
}
