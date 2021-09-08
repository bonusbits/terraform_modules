module "aws_tags" {
  cli_vars                      = {
    orchestrator_version        = var.orchestrator_version
    terraform_environment       = var.terraform_environment
    terraform_version           = var.terraform_version
  }
  source                        = "../../../modules/aws_tags"
  terraform_role                = "eks_compute"
  tfv_custom_aws_tags           = var.custom_aws_tags
}

module "eks_fargate_role" {
  base_aws_tags                 = module.aws_tags.aws_tags
  source                        = "../../../modules/eks_fargate_role"
}

module "k8s_namespaces" {
  for_each                      = var.eks_compute.namespaces
  base_aws_tags                 = module.aws_tags.aws_tags
  labels                        = {}
  name                          = each.value
  source                        = "../../../modules/k8s_namespace"
}

module "eks_fargate_profiles" {
  for_each                      = var.eks_compute.fargate_profiles
  base_aws_tags                 = module.aws_tags.aws_tags
  depends_on                    = [module.eks_fargate_role, module.k8s_namespaces]
  eks_cluster_name              = data.terraform_remote_state.eks_cluster.outputs.eks_cluster.name
  iam_role                      = module.eks_fargate_role.iam_role
  namespace                     = each.value["namespace"]
  name                          = each.value["name"]
  labels                        = each.value["labels"]
  source                        = "../../../modules/eks_fargate_profile"
  subnet_ids                    = data.terraform_remote_state.network.outputs.subnet_ids["private"]
}
