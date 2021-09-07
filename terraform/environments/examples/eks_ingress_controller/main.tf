module "aws_tags" {
  cli_vars                      = {
    orchestrator_version        = var.orchestrator_version
    terraform_environment       = var.terraform_environment
    terraform_version           = var.terraform_version
  }
  source                        = "../../../modules/aws_tags"
  terraform_role                = "eks_ingress_controller"
  tfv_custom_aws_tags           = var.custom_aws_tags
}

module "eks_ingress_controller" {
  base_aws_tags                 = module.aws_tags.aws_tags
  eks_cluster_name              = data.terraform_remote_state.eks_cluster.outputs.eks_cluster.name
  oidc_provider                 = data.terraform_remote_state.eks_cluster.outputs.oidc_provider
  source                        = "../../../modules/eks_ingress_controller"
  tf_vars                       = var.eks_ingress_controller
}
