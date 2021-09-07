locals {
  aws_tags = merge(
    var.tfv_custom_aws_tags,
    {
      Orchestrator_Version        = var.cli_vars.orchestrator_version
      Terraform_Environment       = var.cli_vars.terraform_environment
      Terraform_Role              = var.terraform_role
      Terraform_Version           = var.cli_vars.terraform_version
      Terraform_Workspace         = terraform.workspace
    }
  )
}
