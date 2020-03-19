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

module "security_group" {
  base_aws_tags                 = module.aws_tags.aws_tags
  name                          = "${local.name}-instance"
  rules                         = local.sg_rules
  source                        = "../../../modules/security_group"
  vpc                           = data.terraform_remote_state.network.outputs.vpc
}

module "iam_instance_profiles" {
  base_aws_tags                 = module.aws_tags.aws_tags
  custom_role_policy            = local.iam_profile_custom_role_policy
  managed_policies              = local.managed_policies
  name                          = "${terraform.workspace}-bastion"
  source                        = "../../../modules/iam_instance_profile"
}

# SSH Key Pair
module "key_pair" {
  base_aws_tags                 = module.aws_tags.aws_tags
  name                          = local.name
  public_key                    = file("${path.module}/../../../../vars/secrets/${terraform.workspace}/bastion.pub")
  source                        = "../../../modules/key_pair"
}

module "ec2_instance" {
  ami                           = local.ami_id
  base_aws_tags                 = module.aws_tags.aws_tags
  dns_zone_id                   = data.terraform_remote_state.network.outputs.dns_zone_private.id
  ec2_name                      = local.name
  dns_name                      = "bastion"
  iam_instance_profile          = module.iam_instance_profiles.iam_instance_profile
  key_name                      = module.key_pair.key_pair.key_name
  security_group_ids            = [module.security_group.security_group.id]
  source                        = "../../../modules/ec2_instance"
  subnet_id                     = data.terraform_remote_state.network.outputs.subnet_ids["private"][1]
  tf_vars                       = var.bastion.ec2_instance
  user_data                     = local.user_data
}

# Elastic IP - Cheaper than an unneeded load balancer
//module "eip" {
//  base_aws_tags                 = module.aws_tags.aws_tags
//  depends_on                    = [module.ec2_instance]
//  ec2_instance_id               = module.ec2_instance.instance.id
//  name                          = "${terraform.workspace}-bastion"
//  source                        = "../../../modules/eip"
//  vpc                           = true
//}

module "load_balancer" {
  base_aws_tags                 = module.aws_tags.aws_tags
  name                          = "${terraform.workspace}-bastion"
  load_balancer_type            = "network"
  internal                      = "false"
  subnet_ids                    = data.terraform_remote_state.network.outputs.subnet_ids["public"]
  source                        = "../../../modules/load_balancer"
}

module "target_group" {
  base_aws_tags                 = module.aws_tags.aws_tags
  name                          = "${terraform.workspace}-bastion"
  depends_on                    = [module.ec2_instance, module.load_balancer]
  load_balancer                 = module.load_balancer.load_balancer
  source                        = "../../../modules/target_group"
  tf_vars                       = var.bastion.target_group
  vpc                           = data.terraform_remote_state.network.outputs.vpc
}

module "target_group_attach" {
  ec2_instance_id               = module.ec2_instance.instance_id
  depends_on                    = [module.ec2_instance, module.target_group]
  source                        = "../../../modules/target_group_attach_instance"
  target_group                  = module.target_group.target_group
}
