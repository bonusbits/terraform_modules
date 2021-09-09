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

module "iam_users" {
  for_each                      = var.iam_users
  base_aws_tags                 = module.aws_tags.aws_tags
  custom_user_policy            = local.user_policies[each.key]
  managed_policies              = local.managed_policies[each.key]
  source                        = "../../../modules/iam_user"
  user_name                     = var.iam_users[each.key].user_name
}
