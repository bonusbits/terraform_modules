terraform {
  required_version        = "~> 1.0.5"
  backend "s3" {
    key                   = "eks_apps.tfstate"
  }
  required_providers {
    aws                   = {
      source              = "hashicorp/aws"
      version             = "~> 3.57"
    }
    kubernetes                  = {
      source              = "hashicorp/kubernetes"
      version             = "~> 2.4"
    }
  }
}

