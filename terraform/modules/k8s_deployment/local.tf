locals {
  aws_region                  = data.aws_region.current.name

  aws_tags                    = merge(
    var.base_aws_tags,
    {
      Terraform_Module        = "k8s_deployment"
    }
  )
  tfv_annotations             = merge(local.aws_tags, var.tf_vars.deployment.annotations)
}
