#### Last Updated v2.2.0 (09/07/2021)
# HowTo: Create VPC + NAT Gateway
After setup this is the first step to creating your environment.

## Prerequisites
* [Local Setup](../setup/local_setup.md)
* [Create Terraform State File Bucket](../setup/s3_bucket_tfvars.md)

## New Environment Example Values
We'll use the following for our new environment
* Environment: my_app
* TF Workspace: myapp-dev-use1
* TFVars Bucket: myapp-tfv
* TFVars Bucket Region: us-east-1
* Stack Region: us-east-1

## Fork
Fork the repo to do your own customized setup.

## Update Environment Variables
Create bash function or whatever works for you to set/switch to env vars for you new environment.
| Variable Name | Description |
| :--- | :--- |
| BB_ORCHESTRATOR_PATH          | Path to root of development repo |
| AWS_PROFILE                   | AWS CLI profile config profile name |
| AWS_REGION                    | AWS Region name |
| KUBECONFIG                    | i.e. /../devops/orchestrator/vars/secrets/$TF_WORKSPACE/kubectl |
| KUBE_CONFIG_PATH              | i.e. /../devops/orchestrator/vars/secrets/$TF_WORKSPACE/kubectl |
| TF_WORKSPACE                  | Terraform workspace and config names (i.e. myapp-dev-use1) Hyphens recommended over underscore because it's used to make AWS objects and not all AWS objects support underscores |

```bash
export BB_ORCHESTRATOR_PATH="$HOME/Development/bonusbits/bonusbits_orchestrator"
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

function myapp-dev-use1 {
    export AWS_PROFILE=myapp
    export AWS_REGION=us-east-1
    export TF_WORKSPACE="myapp-dev-use1"
    export KUBECONFIG="${BB_ORCHESTRATOR_PATH}/vars/secrets/${TF_WORKSPACE}/kubectl"
    export KUBE_CONFIG_PATH="${KUBECONFIG}"
}

myapp-dev-use1
```

## Terraform Environment + Role
1. Create folder
   1. ```mkdir $BB_ORCHESTRATOR_PATH/terraform/environments/my_app```
2. Copy Example Terraform role into our new environment
   1. ```cp -R $BB_ORCHESTRATOR_PATH/terraform/environments/examples/network_nat_gateway $BB_ORCHESTRATOR_PATH/terraform/environments/my_app/network```
3. Git add
   1. ```git add $BB_ORCHESTRATOR_PATH/terraform/environments/my_app/*```

## Rake Config
1. Create rake config
   1. ```touch $BB_ORCHESTRATOR_PATH/vars/orchestrator/$TF_WORKSPACE.yml```
2. Copy example content from templates
   1. ```$BB_ORCHESTRATOR_PATH/vars/orchestrator/templates/orchestrator.yml```
   2. ```$BB_ORCHESTRATOR_PATH/vars/orchestrator/templates/terraform.yml```
3. Add content
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
  tfvar_roles_path: vars/terraform/myapp-dev-use1
  s3_backend:
    bucket: myapp-tfv
    region: us-east-1
    key_prefix: workspaces
```

## Terraform Variables
1. Create stack tfvars folder
   1. ```mkdir $BB_ORCHESTRATOR_PATH/vars/terraform/myapp-dev-use1```
2. Copy example Terraform tfvar files
   1. ```cp -R $BB_ORCHESTRATOR_PATH/vars/terraform/examples/network_512.tfvars $BB_ORCHESTRATOR_PATH/vars/terraform/myapp-dev-use1/network.tfvars```
3. Edit any values needed in network.tfvars

## Create Network
1. ```rake init[network]```
   1. ```1 <enter>```
1. ```rake plan[network]```
1. ```rake apply[network]```
