locals {
  aws_tags                      = merge(
    var.base_aws_tags,
    {
      Terraform_Module          = "k8s_service_account"
    }
  )
  merged_annotations            = merge(local.aws_tags, var.annotations)
}
