data "aws_region" "current" {}

data "terraform_remote_state" "cloudwatch_logs" {
  backend                       = "s3"
  config = {
    bucket                      = var.s3_backend.bucket
    region                      = var.s3_backend.region
    key                         = "${var.s3_backend.key_prefix}/${terraform.workspace}/cloudwatch_logs.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend                       = "s3"
  config = {
    bucket                      = var.s3_backend.bucket
    region                      = var.s3_backend.region
    key                         = "${var.s3_backend.key_prefix}/${terraform.workspace}/network.tfstate"
  }
}
