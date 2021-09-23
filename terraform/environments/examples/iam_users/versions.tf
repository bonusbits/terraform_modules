terraform {
required_version          = "~> 1.0.7"
  backend "s3" {
    key                   = "iam_users.tfstate"
    encrypt               = true
  }
  required_providers {
    aws                   = {
      source              = "hashicorp/aws"
      version             = "~> 3.54"
    }
  }
}
