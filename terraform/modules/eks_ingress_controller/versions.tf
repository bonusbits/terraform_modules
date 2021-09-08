terraform {
  required_version        = "~> 1.0.5"
  required_providers {
    aws                   = {
      source              = "hashicorp/aws"
      version             = "~> 3.57"
    }
    helm                  = {
      source              = "hashicorp/helm"
      version             = "~> 2.2"
    }
  }
}
