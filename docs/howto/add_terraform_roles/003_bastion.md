#### Last Updated v2.1.1 (09/07/2021)
# HowTo: Add Bastion EC2 Instance Role

## Prerequisites
1. [Local Setup](../setup/local_setup.md)
2. [Create Terraform State File Bucket](../setup/s3_bucket_tfvars.md)
3. [Network Role](../add_terraform_roles/001_network.md)
4. [Cloudwatch Logs Role](../add_terraform_roles/002_cloudwatch_logs.md)

## New Environment Example Values
* Environment: my_app
* TF Workspace: myapp-dev-use1
* TFVars Bucket: myapp-tfv
* TFVars Bucket Region: us-east-1
* Stack Region: us-east-1
* Role: bastion_eip or bastion_lb
* OS Distro: Ubuntu

## Add Role
1. Copy Example Terraform role into our new environment
    1. ```cp -R $BB_ORCHESTRATOR_PATH/terraform/environments/examples/bastion_eip $BB_ORCHESTRATOR_PATH/terraform/environments/my_app/bastion```
2. Git add
    1. ```git add $BB_ORCHESTRATOR_PATH/terraform/environments/my_app/*```

## Rake Config
1. Edit rake config
    1. ```vim $BB_ORCHESTRATOR_PATH/vars/orchestrator/$TF_WORKSPACE.yml```
2. Add Role to terraform.roles array variable. Without the inline arrow comment. Also the bastion map. 
```yaml
bastion: # <<
  login_user: ubuntu # <<
  ssh_key_name: bastion # <<

orchestrator:
  environment: my_app
  feature_toggles:
    debug: false
    skip_all_prompts: false
    use_secrets_manager: false

terraform:
  roles:
    - network
    - cloudwatch_logs
    - bastion # <<
  tfvar_roles_path: vars/terraform/myapp-dev-use1
  s3_backend:
    bucket: myapp-tfv
    region: us-east-1
    key_prefix: workspaces
```

## Terraform Variables
#### Role Tfvar
1. Copy example Terraform tfvar file
    1. ```cp -R $BB_ORCHESTRATOR_PATH/vars/terraform/examples/bastion_ubuntu_eip.tfvars $BB_ORCHESTRATOR_PATH/vars/terraform/myapp-dev-use1/bastion.tfvars```
2. Edit any values needed in bastion.tfvars
    1. Can set instance type size etc.

#### Access List
With EIP or LB we need an access_list.tfvars with a list of WAN IP addresses to allow to SSH to bastion
1. Create secrets folder
   1. ```rake secrets:folders:create_secrets_folders```
2. Copy the example Terraform tfvar file to secrets folder
    1. ```cp -R $BB_ORCHESTRATOR_PATH/vars/terraform/examples/access_list.tfvars $BB_ORCHESTRATOR_PATH/vars/secrets/myapp-dev-use1/access_list.tfvars```
3. Edit access_list and add IPs
   1. ```vim $BB_ORCHESTRATOR_PATH/vars/secrets/myapp-dev-use1/access_list.tfvars```

## Create SSH Key
Create local SSH Key that will be used to create key pair in AWS
```rake bastion:secrets:create_ssh_key```

## Create Network
1. ```rake init[bastion]```
   1. Select 1 <enter>
2. ```rake plan[bastion]```
3. ```rake apply[bastion]```
