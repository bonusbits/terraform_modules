locals {
  aws_region                    = data.aws_region.current.name
  aws_tags                      = merge(
    var.base_aws_tags,
    {
      Terraform_Module          = "vpc"
    }
  )
  az_count                      = length(data.aws_availability_zones.all.names)
  zone_id_prefix                = substr(data.aws_availability_zone.setup_azs[0].zone_id, 0, 4)
  setup_az_count                = tonumber(var.tf_vars.setup_az_count < local.az_count ? var.tf_vars.setup_az_count : local.az_count)
  name                          = replace(terraform.workspace, "_", "-")
}
