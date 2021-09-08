locals {
  aws_tags                      = merge(
    var.base_aws_tags,
    {
      Terraform_Module          = "k8s_namespace"
    }
  )
}
