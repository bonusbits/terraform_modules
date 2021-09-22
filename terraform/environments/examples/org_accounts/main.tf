module "aws_tags" {
  for_each                      = var.org_accounts
  cli_vars                      = {
    orchestrator_version        = var.orchestrator_version
    terraform_environment       = var.terraform_environment
    terraform_version           = var.terraform_version
  }
  source                        = "../../../modules/aws_tags"
  terraform_role                = "aws_org_accounts"
  tfv_custom_aws_tags           = {
    Environment                 = each.value.environment
    Owner                       = each.value.email
  }
}

# Bastion
module "org_accounts" {
  for_each                      = var.org_accounts
  base_aws_tags                 = module.aws_tags.aws_tags
  name                          = each.value.name
  email                         = each.value.email
  parent_id                     = each.value.parent_id
  source                        = "../../../modules/org_account"
  iam_user_access_to_billing    = each.value.iam_user_access_to_billing
  role_name                     = each.value.role_name
  service_control_policy_id     = each.value.service_control_policy_id
}
