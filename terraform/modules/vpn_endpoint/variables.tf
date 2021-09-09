# Tfvars
variable tf_vars {}

# Role
variable base_aws_tags {}
variable cloudwatch_log_group {}
variable vpc {}
variable private_subnet_ids {}
variable security_group {}
variable dns_servers {type = list(string)}
