data "aws_ami" "amazon_linux1" {
  most_recent               = true
  filter {
    name                    = "name"
    values                  = ["amzn-ami-hvm-2018.*-x86_64-gp2"]
  }
  filter {
    name                    = "virtualization-type"
    values                  = ["hvm"]
  }
  owners                    = ["137112412989"]
}

data "aws_ami" "amazon_linux2" {
  most_recent               = true
  filter {
    name                    = "name"
    values                  = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  filter {
    name                    = "virtualization-type"
    values                  = ["hvm"]
  }
  owners                    = ["137112412989"]
}

data "aws_ami" "ubuntu" {
  most_recent               = true
  filter {
    name                    = "name"
    values                  = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name                    = "virtualization-type"
    values                  = ["hvm"]
  }
  owners                    = ["099720109477"]
}

data "aws_region" "current" {}

data "terraform_remote_state" "cloudwatch_logs" {
  backend                       = "s3"
  config = {
    bucket                      = var.s3_backend.bucket
    region                      = var.s3_backend.region
    key                         = "${var.s3_backend.key_prefix}/${terraform.workspace}/cloudwatch_logs.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend                       = "s3"
  config = {
    bucket                      = var.s3_backend.bucket
    region                      = var.s3_backend.region
    key                         = "${var.s3_backend.key_prefix}/${terraform.workspace}/network.tfstate"
  }
}
