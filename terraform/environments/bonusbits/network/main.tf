module "aws_tags" {
  cli_vars                      = {
    orchestrator_version        = var.orchestrator_version
    terraform_environment       = var.terraform_environment
    terraform_version           = var.terraform_version
  }
  source                        = "../../../modules/aws_tags"
  terraform_role                = "vpc"
  tfv_custom_aws_tags           = var.custom_aws_tags
}

module "vpc" {
  base_aws_tags                 = module.aws_tags.aws_tags
  source                        = "../../../modules/vpc"
  tf_vars                       = merge(var.network.vpc, {multi_az_nat = var.network.multi_az_nat})
}

module "nat_gateway" {
  base_aws_tags                 = module.aws_tags.aws_tags
  source                        = "../../../modules/nat_gateway"
  tf_vars                       = {multi_az_nat = var.network.multi_az_nat}
  route_table_ids               = module.vpc.route_tables.private.*.id
  subnet_ids                    = module.vpc.subnet_ids.public
}

# Security Groups Created by CloudFormation dev
# InternalAccessSecurityGroup - bonusbits-dev-vpc-instance-to-instance - Source Self All Traffic
# RemoteAccessSecurityGroup - bonusbits-dev-vpc-remote-to-instance - All Traffic homeip/32 & SSH 0.0.0.0/0
