data "aws_caller_identity" "current" {}

data "terraform_remote_state" "iam_users" {
  backend                       = "s3"
  config = {
    bucket                      = var.s3_backend.bucket
    region                      = var.s3_backend.region
    key                         = "${var.s3_backend.key_prefix}/${terraform.workspace}/iam_users.tfstate"
  }
}
