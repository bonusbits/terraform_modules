module "aws_tags" {
  cli_vars                      = {
    orchestrator_version        = var.orchestrator_version
    terraform_environment       = var.terraform_environment
    terraform_version           = var.terraform_version
  }
  source                        = "../../../modules/aws_tags"
  terraform_role                = "vpn_endpoint"
  tfv_custom_aws_tags           = var.custom_aws_tags
}

module "security_group" {
  base_aws_tags                 = module.aws_tags.aws_tags
  name                          = "${terraform.workspace}-vpn"
  rules                         = local.sg_rules
  source                        = "../../../modules/security_group"
  vpc                           = data.terraform_remote_state.network.outputs.vpc
}

module "vpn_endpoint" {
  base_aws_tags                 = module.aws_tags.aws_tags
  dns_servers                   = ["8.8.8.8","1.1.1.1"]
  cloudwatch_log_group          = data.terraform_remote_state.cloudwatch_logs.outputs.cloudwatch_log_groups.vpn_endpoint.name
  orchestrator_version          = var.orchestrator_version
  tf_vars                       = var.vpn_endpoint
  source                        = "../../../modules/vpn_endpoint"
  security_group                = module.security_group.security_group
  terraform_environment         = var.terraform_environment
  terraform_version             = var.terraform_version
  vpc                           = data.terraform_remote_state.network.outputs.vpc
  private_subnet_ids            = data.terraform_remote_state.network.outputs.subnet_ids["private"]
}
