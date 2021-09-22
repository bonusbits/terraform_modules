module "aws_tags" {
  cli_vars                      = {
    orchestrator_version        = var.orchestrator_version
    terraform_environment       = var.terraform_environment
    terraform_version           = var.terraform_version
  }
  source                        = "../../../modules/aws_tags"
  terraform_role                = "org_policies"
  tfv_custom_aws_tags           = var.custom_aws_tags
}

# Bastion
module "org_policies" {
  for_each                      = var.org_policies
  base_aws_tags                 = module.aws_tags.aws_tags
  description                   = each.value.description
  name                          = each.value.name
  type                          = each.value.type
  content                       = local.policies[each.key]
  source                        = "../../../modules/org_policy"
}
