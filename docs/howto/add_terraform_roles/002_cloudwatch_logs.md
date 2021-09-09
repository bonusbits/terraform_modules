#### Last Updated: 09/08/2021
# HowTo: Add Cloudwatch Log Groups Role

## Prerequisites
1. [Local Setup](../setup/local_setup.md)
2. [Create Terraform State File Bucket](../setup/s3_bucket_tfvars.md)
3. [Network Role](./001_network.md)

## New Environment Example Values
* Environment: demo
* TF Workspace: demo-dev-use1
* TFVars Bucket: demo-tfv
* TFVars Bucket Region: us-east-1
* Stack Region: us-east-1

## Add Role
1. Copy Example Terraform role into our new environment
   1. ```cp -R $BB_ORCHESTRATOR_PATH/terraform/environments/examples/cloudwatch_logs $BB_ORCHESTRATOR_PATH/terraform/environments/demo/cloudwatch_logs```
2. Git add
    1. ```git add $BB_ORCHESTRATOR_PATH/terraform/environments/demo/*```

## Rake Config
1. Edit rake config
    1. ```vim $BB_ORCHESTRATOR_PATH/vars/orchestrator/$TF_WORKSPACE.yml```
2. Add Role to terraform.roles array variable. Without the inline arrow comment
```yaml
orchestrator:
  environment: demo
  feature_toggles:
    debug: false
    skip_all_prompts: false
    use_secrets_manager: false

terraform:
  roles:
    - network
    - cloudwatch_logs # <<
  tfvar_roles_path: vars/terraform/demo-dev-use1
  s3_backend:
    bucket: demo-tfv
    region: us-east-1
    key_prefix: workspaces
```

## Terraform Variables
1. Copy example Terraform tfvar files
    1. ```cp -R $BB_ORCHESTRATOR_PATH/vars/terraform/examples/cloudwatch_logs.tfvars $BB_ORCHESTRATOR_PATH/vars/terraform/$TF_WORKSPACE/cloudwatch_logs.tfvars```
2. Edit any values needed in cloudwatch_logs.tfvars
   1. At this point may not have any log groups to add
   2. If setting up Bastion next then we can add that now as an example
```hcl
cloudwatch_logs = {
  bastion = {
    retention_in_days   = "90"
    name                = "/demo-dev-use1/ec2/bastion"
  }
}    
```

## Wait for All Roles (Option 1)
We can wait until you have all the roles setup and then use init, plan and apply calls without specifying the role to run them all in order of how they are listed in the rake config terraform:roles array.
1. ```rake init```
   1. ```1 <enter>```
2. ```rake plan```
3. ```rake apply```

## Create Role Objects (Option 2)
1. ```rake init[cloudwatch_logs]```
   1. ```1 <enter>```
2. ```rake plan[cloudwatch_logs]```
3. ```rake apply[cloudwatch_logs]```
