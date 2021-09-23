terraform {
  required_version        = "~> 1.0.7"
  backend "s3" {
    key                   = "eks_cluster.tfstate"
    encrypt               = true
  }
  required_providers {
    aws                   = {
      source              = "hashicorp/aws"
      version             = "~> 3.59"
    }
    null                  = {
      source              = "hashicorp/null"
      version             = "~> 3.1"
    }
    template                  = {
      source              = "hashicorp/template"
      version             = "~> 2.2"
    }
  }
}
