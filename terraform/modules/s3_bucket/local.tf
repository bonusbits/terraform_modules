locals {
  aws_tags                      = merge(
    var.base_aws_tags,
    {
      Name                      = var.bucket_name
      Terraform_Module          = "s3_bucket"
    }
  )
}
