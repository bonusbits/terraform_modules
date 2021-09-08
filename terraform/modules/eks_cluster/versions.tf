terraform {
  required_version        = "~> 1.0.5"
  required_providers {
    aws                   = {
      source              = "hashicorp/aws"
      version             = "~> 3.57"
    }
    # For thumbprint_list
    tls                   = {
      source              = "hashicorp/tls"
      version             = "~> 3.1"
    }
  }
}
