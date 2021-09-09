terraform {
required_version          = "~> 1.0.5"
  backend "s3" {
    bucket                = "alma-tfstate"
    key                   = "iam_users.tfstate"
    region                = "us-west-2"
    workspace_key_prefix  = "workspaces"
  }
  required_providers {
    aws                   = {
      source              = "hashicorp/aws"
      version             = "~> 3.54"
    }
  }
}
