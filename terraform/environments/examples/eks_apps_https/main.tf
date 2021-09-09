module "aws_tags" {
  cli_vars                      = {
    orchestrator_version        = var.orchestrator_version
    terraform_environment       = var.terraform_environment
    terraform_version           = var.terraform_version
  }
  source                        = "../../../modules/aws_tags"
  terraform_role                = "eks_apps"
  tfv_custom_aws_tags           = var.custom_aws_tags
}

//module "ecr_tags" {
//  for_each                      = var.eks_apps
//  base_aws_tags                 = module.aws_tags.aws_tags
//  source                        = "../../../modules/ecr_tags"
//  repository_name               = var.eks_apps[each.key].repo
//}

module "k8s_deployment" {
  for_each                      = var.eks_apps
  base_aws_tags                 = module.aws_tags.aws_tags
//  image                         = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${local.aws_region}.amazonaws.com/${var.eks_apps[each.key].repo}:${module.ecr_tags[each.key].most_recent_tag}"
  image                         = var.eks_apps[each.key].repo
  source                        = "../../../modules/k8s_deployment"
  tf_vars                       = merge(
    {deployment                 = var.eks_apps[each.key].deployment},
    {namespace                  = var.eks_apps[each.key].namespace}
  )
}

module "k8s_service" {
  for_each                      = var.eks_apps
  base_aws_tags                 = module.aws_tags.aws_tags
  source                        = "../../../modules/k8s_service"
  tf_vars                       = merge(
    {service                    = var.eks_apps[each.key].service},
    {namespace                  = var.eks_apps[each.key].namespace}
  )
}

module "k8s_ingress" {
  for_each                      = var.eks_apps
  base_aws_tags                 = module.aws_tags.aws_tags
  certificate_arn               = data.aws_acm_certificate.issued[each.key].arn
  public_access_cidrs           = local.public_access_cidrs
  source                        = "../../../modules/k8s_ingress"
  tf_vars                       = merge(
    {ingress                    = var.eks_apps[each.key].ingress},
    {namespace                  = var.eks_apps[each.key].namespace},
    {aws_tag_name               = each.key}
  )
}
