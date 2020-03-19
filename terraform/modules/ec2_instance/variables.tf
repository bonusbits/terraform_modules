# TFVars
variable tf_vars {}

# Roles
variable ami {type = string}
variable base_aws_tags {}
variable dns_name {type = string}
variable dns_zone_id {type = string}
variable ec2_name {type = string}
variable iam_instance_profile {}
variable key_name {type = string}
variable security_group_ids {type = list(string)}
variable subnet_id {type = string}
variable user_data {type = string}
