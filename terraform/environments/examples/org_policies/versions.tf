terraform {
  required_version        = "~> 1.0.5"
  backend "s3" {
    key                   = "org_policies.tfstate"
    encrypt               = true
  }
}

