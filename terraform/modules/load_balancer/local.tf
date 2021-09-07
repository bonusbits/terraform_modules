locals {
  aws_tags                      = merge(
    var.base_aws_tags,
    {
      Terraform_Module          = "load_balancer"
    }
  )
}
