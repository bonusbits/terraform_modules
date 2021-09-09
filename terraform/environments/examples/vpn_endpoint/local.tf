locals {
  aws_region                    = data.aws_region.current.name

  sg_rules                      = tomap({
    "ingress_1"                   = {
      "description"             = ""
      "type"                    = "ingress"
      "from_port"               = "0"
      "to_port"                 = "0"
      "protocol"                = "-1"
      "cidr_blocks"             = ["0.0.0.0/0"]
    }
    "egress_1"                    = {
      "description"             = ""
      "type"                    = "egress"
      "from_port"               = "0"
      "to_port"                 = "0"
      "protocol"                = "-1"
      "cidr_blocks"             = ["0.0.0.0/0"]
    }
  })
}
