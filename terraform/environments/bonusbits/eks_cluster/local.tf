locals {
  cidr_list_office              = values(var.access_lists.office)
  cidr_list_remote               = values(var.access_lists.remote)
  cidr_list_stack_nats          = formatlist("%s/32",data.terraform_remote_state.network.outputs.nat_public_ip)

  public_access_cidrs           = concat(local.cidr_list_office, local.cidr_list_remote, local.cidr_list_stack_nats)

  # Node Group Private so only need VPC CIDR
  node_group_sg_rules           = tomap({
    "vpc_access"                = {
      "description"             = ""
      "type"                    = "ingress"
      "from_port"               = "0"
      "to_port"                 = "0"
      "protocol"                = "-1"
      "cidr_blocks"             = [data.terraform_remote_state.network.outputs.vpc.cidr_block]
    }
    "outbound"                  = {
      "description"             = ""
      "type"                    = "egress"
      "from_port"               = "0"
      "to_port"                 = "0"
      "protocol"                = "-1"
      "cidr_blocks"             = ["0.0.0.0/0"]
    }
  })
}
