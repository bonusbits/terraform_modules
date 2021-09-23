terraform {
  required_version        = "~> 1.0.7"
  backend "s3" {
    key                   = "cloudwatch_logs.tfstate"
    encrypt               = true
  }
}

