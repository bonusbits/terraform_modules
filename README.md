[![Project Release](https://img.shields.io/badge/release-v2.1.1-blue.svg)](https://github.com/bonusbits/bonusbits_orchestrator)
[![Circle CI](https://circleci.com/gh/bonusbits/bonusbits_orchestrator/tree/master.svg?style=shield)](https://circleci.com/gh/bonusbits/bonusbits_orchestrator/tree/master)
[![GitHub issues](https://img.shields.io/github/issues/bonusbits/bonusbits_orchestrator.svg)](https://github.com/bonusbits/bonusbits_orchestrator/issues)

![](docs/images/ruby.png)![](docs/images/aws.png)![](docs/images/terraform.png)![](docs/images/k8s.png)![](docs/images/helm.png)![](docs/images/docker.png)![](docs/images/packer.png)

## Purpose
Ruby CLI Wrapper for AWS, Chef, Docker, Terraform, Helm, Kubectl and Packer. Can be used to build and deploy AWS and local resources. Somewhat, easy to add your own custom Terraform roles or Ruby rake tasks and libraries for own environments. The idea is to have one place to control many different infrastructure tools for multiple environments. One devops tool to rule them all! Also, a it's good code base to grab examples from to help you with our own custom projects.

## HowTo
### Setup
* [Local Setup](./docs/howto/setup/local_setup.md)
* [Create Terraform State File Bucket](./docs/howto/setup/s3_bucket_tfvars.md)
* [Usage](./docs/howto/setup/usage.md)

### Create Network
* [Create Network (VPC + NAT)](./docs/howto/add_terraform_roles/001_network.md)

### Add Terraform Roles
Add Terraform Roles to customize your environment
* [Cloudwatch Log Groups](./docs/howto/add_terraform_roles/002_cloudwatch_logs.md)
* [Bastion](./docs/howto/add_terraform_roles/003_bastion.md)
