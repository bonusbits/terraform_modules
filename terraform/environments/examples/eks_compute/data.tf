data "terraform_remote_state" "eks_cluster" {
  backend                       = "s3"
  config                        = {
    bucket                      = var.s3_backend.bucket
    region                      = var.s3_backend.region
    key                         = "${var.s3_backend.key_prefix}/${terraform.workspace}/eks_cluster.tfstate"
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
