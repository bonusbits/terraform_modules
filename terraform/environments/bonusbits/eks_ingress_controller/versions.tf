terraform {
  required_version        = "~> 1.0.5"
  backend "s3" {
    key                   = "eks_ingress_controller.tfstate"
  }
  required_providers {
    aws                   = {
      source              = "hashicorp/aws"
      version             = "~> 3.57"
    }
    helm                  = {
      source              = "hashicorp/helm"
      version             = "~> 2.2"
    }
    kubernetes                  = {
      source              = "hashicorp/kubernetes"
      version             = "~> 2.4"
    }
  }
}

