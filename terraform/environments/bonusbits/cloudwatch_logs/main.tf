module "aws_tags" {
  cli_vars                      = {
    orchestrator_version        = var.orchestrator_version
    terraform_environment       = var.terraform_environment
    terraform_version           = var.terraform_version
  }
  source                        = "../../../modules/aws_tags"
  terraform_role                = "cloudwatch_logs"
  tfv_custom_aws_tags           = var.custom_aws_tags
}

# Bastion
module "cloudwatch_log_groups" {
  for_each                      = var.cloudwatch_logs
  base_aws_tags                 = module.aws_tags.aws_tags
  name                          = var.cloudwatch_logs[each.key].name
  retention_in_days             = var.cloudwatch_logs[each.key].retention_in_days
  source                        = "../../../modules/cloudwatch_log_group"
}
