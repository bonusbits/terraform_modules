# TFVars
variable access_lists {}
variable custom_aws_tags {}
variable eks_apps {}

# CLI Passed Vars
variable orchestrator_version {type = string}
variable s3_backend {type = map(string)}
variable terraform_environment {type = string}
variable terraform_version {type = string}
