locals {
  aws_region                    = data.aws_region.current.name
  aws_tags                      = merge(
    var.base_aws_tags,
    {
      Terraform_Module          = "eks_cluster"
    }
  )
  name                          = terraform.workspace
  name_hyphens                  = replace(terraform.workspace, "_", "-")
  sts_principal                 = "sts.${data.aws_partition.current.dns_suffix}"
}
