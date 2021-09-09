terraform {
  required_version        = "~> 1.0.5"
  backend "s3" {
    key                   = "efs.tfstate"
  }
  required_providers {
    aws                   = {
      source              = "hashicorp/aws"
      version             = "~> 3.57"
    }
  }
}

