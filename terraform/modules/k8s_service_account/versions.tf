terraform {
  required_version        = "~> 1.0.7"
  required_providers {
    kubernetes            = {
      source              = "hashicorp/kubernetes"
      version             = "~> 2.4"
    }
  }
}
