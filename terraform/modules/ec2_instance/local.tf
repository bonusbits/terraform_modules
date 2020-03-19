locals {
  aws_tags                      = merge(
    var.base_aws_tags,
    {
      Name                      = var.ec2_name
      Terraform_Module          = "ec2_instance"
    }
  )
}
