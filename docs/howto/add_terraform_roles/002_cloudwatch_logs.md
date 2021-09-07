#### Last Updated v2.1.1 (09/07/2021)
# HowTo: Add Cloudwatch Log Groups Role

## Prerequisites
1. [Local Setup](../setup/local_setup.md)
2. [Create Terraform State File Bucket](../setup/s3_bucket_tfvars.md)
3. [Network Role](../add_terraform_roles/001_network.md)

## New Environment Example Values
* Environment: my_app
* TF Workspace: myapp-dev-use1
* TFVars Bucket: myapp-tfv
* TFVars Bucket Region: us-east-1
* Stack Region: us-east-1

## Add Role
1. Copy Example Terraform role into our new environment
   1. ```cp -R $BB_ORCHESTRATOR_PATH/terraform/environments/examples/cloudwatch_logs $BB_ORCHESTRATOR_PATH/terraform/environments/my_app/cloudwatch_logs```
2. Git add
    1. ```git add $BB_ORCHESTRATOR_PATH/terraform/environments/my_app/*```

## Rake Config
1. Edit rake config
    1. ```vim $BB_ORCHESTRATOR_PATH/vars/orchestrator/$TF_WORKSPACE.yml```
2. Add Role to terraform.roles array variable. Without the inline arrow comment
```yaml
orchestrator:
  environment: my_app
  feature_toggles:
    debug: false
    skip_all_prompts: false
    use_secrets_manager: false

terraform:
  roles:
    - network
    - cloudwatch_logs # <<
  tfvar_roles_path: vars/terraform/myapp-dev-use1
  s3_backend:
    bucket: myapp-tfv
    region: us-east-1
    key_prefix: workspaces
```

## Terraform Variables
1. Copy example Terraform tfvar files
    1. ```cp -R $BB_ORCHESTRATOR_PATH/vars/terraform/examples/cloudwatch_logs.tfvars $BB_ORCHESTRATOR_PATH/vars/terraform/myapp-dev-use1/cloudwatch_logs.tfvars```
2. Edit any values needed in cloudwatch_logs.tfvars
   1. At this point may not have any log groups to add
   2. If setting up Bastion next then we can add that now as an example
```hcl
cloudwatch_logs = {
  bastion = {
    retention_in_days   = "90"
    name                = "/myapp-dev-use1/ec2/bastion"
  }
}    
```

## Create Network
1. ```rake init[cloudwatch_logs]```
   1. Select 1 <enter>
2. ```rake plan[cloudwatch_logs]```
3. ```rake apply[cloudwatch_logs]```
