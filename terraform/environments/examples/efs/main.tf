module "aws_tags" {
  cli_vars                      = {
    orchestrator_version        = var.orchestrator_version
    terraform_environment       = var.terraform_environment
    terraform_version           = var.terraform_version
  }
  source                        = "../../../modules/aws_tags"
  terraform_role                = "bastion"
  tfv_custom_aws_tags           = var.custom_aws_tags
}

module "efs" {
  for_each                      = var.efs
  base_aws_tags                 = module.aws_tags.aws_tags
  name_suffix                   = "${terraform.workspace}-${each.key}"
  performance_mode              = var.efs[each.key].performance_mode
  security_group_ids            = data.terraform_remote_state.network.outputs.security_groups["private"].id
  source                        = "../../../modules/efs"
  subnet_ids                    = data.terraform_remote_state.network.outputs.subnet_ids["private"]
  throughput_in_mibps           = var.efs[each.key].throughput_in_mibps
  throughput_mode               = var.efs[each.key].throughput_mode
}
