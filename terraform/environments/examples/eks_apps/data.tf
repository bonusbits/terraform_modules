data "aws_region" "current" {}

//data "aws_caller_identity" "current" {}

//data "aws_acm_certificate" "issued" {
//  domain   = "www.bonusbits.com"
//  statuses = ["ISSUED"]
//}

# Set KUBE_CONFIG_PATH environment variable and the kubernetes provider automatically uses that path for config to authenticate to cluster.
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs

# For NAT IP List in Local
data "terraform_remote_state" "network" {
  backend                       = "s3"
  config = {
    bucket                      = var.s3_backend.bucket
    region                      = var.s3_backend.region
    key                         = "${var.s3_backend.key_prefix}/${terraform.workspace}/network.tfstate"
  }
}
