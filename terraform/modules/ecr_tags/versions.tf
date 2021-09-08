terraform {
  required_version        = "~> 1.0.5"
  required_providers {
    external              = {
      source              = "hashicorp/external"
      version             = "~> 2.1"
    }
  }
}
