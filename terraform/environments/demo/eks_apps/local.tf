locals {
  aws_region                    = data.aws_region.current.name

  cidr_list_remote               = values(var.access_lists.remote)
  cidr_list_stack_nats          = formatlist("%s/32",data.terraform_remote_state.network.outputs.nat_public_ip)

  public_access_cidrs           = concat(
    local.cidr_list_remote,
    local.cidr_list_stack_nats
  )
}
