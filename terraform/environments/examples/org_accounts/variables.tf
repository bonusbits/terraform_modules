# TFVars
variable custom_aws_tags {}
variable org_accounts {}

# CLI Passed Vars
variable orchestrator_version {type = string}
variable s3_backend {type = map(string)}
variable terraform_environment {type = string}
variable terraform_version {type = string}
