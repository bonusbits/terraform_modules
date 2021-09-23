terraform {
  required_version        = "~> 1.0.7"
  required_providers {
    aws                   = {
      source              = "hashicorp/aws"
      version             = "~> 3.59"
    }
    # For thumbprint_list
    tls                   = {
      source              = "hashicorp/tls"
      version             = "~> 3.1"
    }
  }
}
