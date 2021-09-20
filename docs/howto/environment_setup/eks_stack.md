#### Last Updated: 09/08/2021
# HowTo: Quick Start Guide to Setup EKS Stack
This includes all the setup to recreate an EKS myapp project stack as an example. Name it after you project in lowercase no spaces.  

## Prerequisites
* [Local Setup](../setup/local_setup.md)
* [Create Terraform State File Bucket](../setup/s3_bucket_tfstate.md)

## New Environment Example Values
We'll use the following for our new environment
* Environment: myapp
* TF Workspace: myapp-dev-use1
* TFVars Bucket: myapp-tfv
* TFVars Bucket Region: us-east-1
* Stack Region: us-east-1

## Fork Repo
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
| TF_WORKSPACE                  | Terraform workspace and config names (i.e. demo-dev-use1) Hyphens recommended over underscore because it's used to make AWS objects and not all AWS objects support underscores |

```bash
export BB_ORCHESTRATOR_PATH="$HOME/Development/bonusbits/bonusbits_orchestrator"
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

function demo-dev-use1 {
    export AWS_PROFILE=myapp
    export AWS_REGION=us-east-1
    export TF_WORKSPACE="myapp-dev-use1"
    export KUBECONFIG="${BB_ORCHESTRATOR_PATH}/vars/secrets/${TF_WORKSPACE}/kubectl"
    export KUBE_CONFIG_PATH="${KUBECONFIG}"
}

demo-dev-use1
```

## Example Setup Script
* [EKS Project Setup Script](../../../files/environment_setup/eks_stack.sh)
* ```./project_setup.sh -p myapp```

## Edits
1. tfvar files
   1. Required for Bastion and EKS: access_list.tfvars
      1. remote map should include your WAN IP address, remove the examples
   2. Find/Replace 
      1. $BB_ORCHESTRATOR_PATH/vars/terraform/$TF_WORKSPACE/*.tfvars
      2. demo > myapp
