terraform {
  required_version        = "~> 1.0.7"
  required_providers {
    aws                   = {
      source              = "hashicorp/aws"
      version             = "~> 3.59"
    }
    helm                  = {
      source              = "hashicorp/helm"
      version             = "~> 2.2"
    }
  }
}
