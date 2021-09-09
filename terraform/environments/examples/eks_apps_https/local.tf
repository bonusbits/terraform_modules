locals {
  aws_region                    = data.aws_region.current.name

  cidr_list_remote               = values(var.access_lists.remote)
  cidr_list_stack_nats          = formatlist("%s/32",data.terraform_remote_state.network.outputs.nat_public_ip)

  public_access_cidrs           = concat(
    local.cidr_list_remote,
    local.cidr_list_stack_nats
  )

//  certificate_arn_annotations   = {
//    "alb.ingress.kubernetes.io/certificate-arn"  = data.aws_acm_certificate.issued.arn
//  }
//  merged_annotations            = merge(var.tf_vars.ingress.annotations, local.certificate_arn_annotations)
}
