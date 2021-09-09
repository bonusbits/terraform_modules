data "aws_region" "current" {}

locals {
  aws_region                  = data.aws_region.current.name
  name                        = terraform.workspace
  name_hyphens                = replace(terraform.workspace, "_", "-")
}

resource "aws_efs_file_system" "default" {
  creation_token              = "${local.name_hyphens}-${var.name_suffix}"
  encrypted                   = false
  performance_mode            = var.performance_mode
  throughput_mode             = var.throughput_mode
  provisioned_throughput_in_mibps  = var.throughput_in_mibps

  tags                        = local.aws_tags
}

resource "aws_efs_mount_target" "default" {
  for_each                    = {for x in var.subnet_ids : x => x}
  //for_each                    = {for k, v in var.parameters : k => v if v.efs == "true"}
  file_system_id              = aws_efs_file_system.default.id
  security_groups             = [var.security_group_ids]
  subnet_id                   = each.value
}
