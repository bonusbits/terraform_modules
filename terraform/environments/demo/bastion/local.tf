locals {
  os_distro                     = var.bastion.ec2_instance.os_distro
  ami_id                        = local.os_distro == "amazon_linux1" ? data.aws_ami.amazon_linux1.id : (
                                      local.os_distro == "amazon_linux2" ? data.aws_ami.amazon_linux2.id : (
                                      local.os_distro == "ubuntu" ? data.aws_ami.ubuntu.id : "UNKNOWN"
                                    )
                                  )
  name                          = "${terraform.workspace}-bastion"
  user_data                     = templatefile(
                                        local.os_distro == "amazon_linux1" ? "${path.module}/templates/user_data/amazon_linux1.sh.tmpl" : (
                                        local.os_distro == "amazon_linux2" ? "${path.module}/templates/user_data/amazon_linux2.sh.tmpl" : (
                                        local.os_distro == "ubuntu" ? "${path.module}/templates/user_data/ubuntu.sh.tmpl" : "UNKNOWN"
                                      )
                                    ),
                                    {
                                      hostname                    = local.name
                                    }
                                  )

  iam_profile_custom_role_policy = templatefile(
  "${path.module}/templates/iam_instance_profile/policy_default.json.tmpl",
    {
      cloudwatch_logs_group_arn  = data.terraform_remote_state.cloudwatch_logs.outputs.cloudwatch_log_groups.bastion.arn
    }
  )

  managed_policies              = tomap({
    "cloudwatch_read"           = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
    "ec2_read"                  = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
    "route53_read"              = "arn:aws:iam::aws:policy/AmazonRoute53ReadOnlyAccess"
    "s3_read"                   = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    "ssm_read"                  = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  })

  cidr_list_office              = var.access_lists.office
  cidr_list_remote              = var.access_lists.remote

  public_access_cidrs           = merge(
    local.cidr_list_office,
    local.cidr_list_remote
  )

  sg_rules_private             = tomap({
    "ingress_vpc"               = {
      "description"             = "vpc"
      "type"                    = "ingress"
      "from_port"               = "0"
      "to_port"                 = "0"
      "protocol"                = "-1"
      "cidr_blocks"             = [data.terraform_remote_state.network.outputs.vpc.cidr_block]
    }
    "egress"                    = {
      "description"             = ""
      "type"                    = "egress"
      "from_port"               = "0"
      "to_port"                 = "0"
      "protocol"                = "-1"
      "cidr_blocks"             = ["0.0.0.0/0"]
    }
  })

  sg_public_rules               = {for k, v in local.public_access_cidrs : k => {
                                    "description" = k
                                    "type" = "ingress"
                                    "from_port" = "22"
                                    "to_port" = "22"
                                    "protocol" = "tcp"
                                    "cidr_blocks" = [v]
                                  }
  }

  sg_rules                      = merge(local.sg_rules_private, local.sg_public_rules)
}
