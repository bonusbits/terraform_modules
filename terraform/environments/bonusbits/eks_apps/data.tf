data "aws_region" "current" {}

//data "aws_caller_identity" "current" {}

data "aws_acm_certificate" "issued" {
  for_each = var.eks_apps
  domain   = var.eks_apps[each.key].ingress.cert_domain
  statuses = ["ISSUED"]
}

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
