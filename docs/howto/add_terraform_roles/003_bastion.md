#### Last Updated: 09/08/2021
# HowTo: Add Bastion EC2 Instance Role

## Prerequisites
1. [Local Setup](../setup/local_setup.md)
2. [Create Terraform State File Bucket](../setup/s3_bucket_tfvars.md)
3. [Network Role](./001_network.md)
4. [Cloudwatch Logs Role](./002_cloudwatch_logs.md)

## New Environment Example Values
* Environment: demo
* TF Workspace: demo-dev-use1
* TFVars Bucket: demo-tfv
* TFVars Bucket Region: us-east-1
* Stack Region: us-east-1
* Role: bastion_eip or bastion_lb
* OS Distro: Ubuntu

## Add Role
1. Copy Example Terraform role into our new environment
    1. ```cp -R $BB_ORCHESTRATOR_PATH/terraform/environments/examples/bastion_eip $BB_ORCHESTRATOR_PATH/terraform/environments/demo/bastion```
2. Git add
    1. ```git add $BB_ORCHESTRATOR_PATH/terraform/environments/demo/*```

## Rake Config
1. Edit rake config
    1. ```vim $BB_ORCHESTRATOR_PATH/vars/orchestrator/$TF_WORKSPACE.yml```
2. Add Role to terraform.roles array variable. Without the inline arrow comment. Also the bastion map. 
```yaml
bastion: # <<
  login_user: ubuntu # <<
  ssh_key_name: bastion # <<

orchestrator:
  environment: demo
  feature_toggles:
    debug: false
    skip_all_prompts: false
    use_secrets_manager: false

terraform:
  roles:
    - network
    - cloudwatch_logs
    - bastion # <<
  tfvar_roles_path: vars/terraform/demo-dev-use1
  shared_tfvar_files:
    - vars/secrets/demo-shared/access_lists.tfvars
  s3_backend:
    bucket: demo-tfv
    region: us-east-1
    key_prefix: workspaces
```

## Terraform Variables
#### Role Tfvar
1. Copy example Terraform tfvar file
    1. ```cp -R $BB_ORCHESTRATOR_PATH/vars/terraform/examples/bastion_ubuntu_eip.tfvars $BB_ORCHESTRATOR_PATH/vars/terraform/$TF_WORKSPACE/bastion.tfvars```
2. Edit any values needed in bastion.tfvars
    1. Can set instance type size etc.

#### Access List
With EIP or LB we need an access_list.tfvars with a list of WAN IP addresses to allow to SSH to bastion
1. Create secrets folder
   1. ```rake secrets:folders:create_secrets_folders```
2. Copy the example Terraform tfvar file to secrets folder
    1. ```cp -R $BB_ORCHESTRATOR_PATH/vars/terraform/examples/access_lists.tfvars $BB_ORCHESTRATOR_PATH/vars/secrets/$TF_WORKSPACE/access_lists.tfvars```
3. Edit access_list and add IPs
   1. ```vim $BB_ORCHESTRATOR_PATH/vars/secrets/$TF_WORKSPACE/access_lists.tfvars```

## Create SSH Key
Create local SSH Key that will be used to create key pair in AWS
```rake bastion:secrets:create_ssh_key```

## Wait for All Roles (Option 1)
We can wait until you have all the roles setup and then use init, plan and apply calls without specifying the role to run them all in order of how they are listed in the rake config terraform:roles array.
1. ```rake init```
   1. ```1 <enter>```
2. ```rake plan```
3. ```rake apply```

## Create Role Objects (Option 2)
1. ```rake init[bastion]```
   1. ```1 <enter>```
2. ```rake plan[bastion]```
3. ```rake apply[bastion]```

## Test Completion
```rake bastion:tests:instance_status_loop```
```rake bastion:tests:tail_cloud_init_loop```

## Add Users (Optional)
[Add Users](../bastion/add_bastion_users.md)
