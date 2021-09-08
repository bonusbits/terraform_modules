locals {
  aws_tags                    = merge(
    var.base_aws_tags,
    {
      Terraform_Module        = "k8s_ingress"
    }
  )

  inbound_cidrs_annotations                = {
    "alb.ingress.kubernetes.io/inbound-cidrs" = join(", ", var.public_access_cidrs)
  }

  certificate_arn_annotations                = {
    "alb.ingress.kubernetes.io/certificate-arn"  = var.certificate_arn
  }

  # To set the security group name when created by controller
  name_tag_annotations                = {
    "alb.ingress.kubernetes.io/tags"  = "Name=${terraform.workspace}-${var.tf_vars.aws_tag_name}"
  }

  merged_annotations            = merge(local.aws_tags, var.tf_vars.ingress.annotations, local.inbound_cidrs_annotations, local.certificate_arn_annotations, local.name_tag_annotations)
}
