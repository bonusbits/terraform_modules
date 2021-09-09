module "aws_tags" {
  cli_vars                      = {
    orchestrator_version        = var.orchestrator_version
    terraform_environment       = var.terraform_environment
    terraform_version           = var.terraform_version
  }
  source                        = "../../../modules/aws_tags"
  terraform_role                = "s3"
  tfv_custom_aws_tags           = var.custom_aws_tags
}

module "s3_buckets" {
  for_each                      = var.s3_buckets
  base_aws_tags                 = module.aws_tags.aws_tags
  block_public_access           = var.s3_buckets[each.key].block_public_access
  bucket_name                   = var.s3_buckets[each.key].bucket_name
  bucket_policy                 = local.policies[each.key]
  enable_versioning             = var.s3_buckets[each.key].enable_versioning
  source                        = "../../../modules/s3_bucket"
}
