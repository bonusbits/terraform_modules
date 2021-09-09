# Roles
variable base_aws_tags {}
variable security_group_ids {}
variable subnet_ids {}
variable name_suffix {type = string}
variable performance_mode {
    type = string
    default = "generalPurpose"
    # maxIO or generalPurpose
}
variable throughput_mode {
    type = string
    default = "bursting"
    # provisioned or bursting
}
variable throughput_in_mibps {
    type = string
    default = "0"
    # 1-1024
}
