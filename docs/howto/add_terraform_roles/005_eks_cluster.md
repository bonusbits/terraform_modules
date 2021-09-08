#### Last Updated v2.2.0 (09/07/2021)
# HowTo: Add EKS Cluster Role

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

## Cloudwatch Logs
Add eks_cluster section to cloudwatch_logs.tfvars. Have to do this prior to creating the EKS cluster so we gain control of the log group that it will automatically generate.
```hcl
cloudwatch_logs = {
  eks_cluster = {
    retention_in_days   = "90"
    name                = "/aws/eks/<cluster name>/cluster"
  }
}
```
##### Example
```hcl
cloudwatch_logs = {
  eks_cluster = {
    retention_in_days   = "90"
    name                = "/aws/eks/myapp-dev-use1/cluster"
  }
}
```

#### Init/Plan/Apply
1. ```rake init[cloudwatch_logs]```
2. ```rake plan[cloudwatch_logs]```
3. ```rake apply[cloudwatch_logs]```

## EKS Cluster Role
Now we copy and customize the example eks_cluster role to our environment
#### Terraform Role
Copy example role to environment folder/s. i.e. bonusbits
```cp -R $BB_ORCHESTRATOR_PATH/terraform/environments/examples/eks_cluster $BB_ORCHESTRATOR_PATH/terraform/environments/my_app/eks_cluster```

#### TFVars File
1. Copy example eks_cluster.tfvars file to our environment folder/s. i.e. myapp-dev-use1
```cp -R $BB_ORCHESTRATOR_PATH/vars/terraform/examples/eks_cluster.tfvars $BB_ORCHESTRATOR_PATH/vars/terraform/myapp-dev-use1/eks_cluster.tfvars```
2. Edit tfvars as needed

#### Rake Config
Add the new role to the rake config. Without the inline arrows comment...
```yaml
terraform:
  roles:
    - network
    - cloudwatch_logs
    - bastion
    - eks_cluster # <<
  tfvar_roles_path: vars/terraform/myapp-dev-use1
  shared_tfvar_files:
     - vars/secrets/myapp-shared/access_lists.tfvars
  s3_backend:
     bucket: myapp-tfv
     region: us-east-1
     key_prefix: workspaces
```

#### Access List
We use the access list to add WAN IPs allowed to access the EKS Cluster Endpoint on Public.
1. Create secrets folder
   1. ```rake secrets:folders:create_secrets_folders```
2. Copy the example Terraform tfvar file to secrets folder
   1. ```cp -R $BB_ORCHESTRATOR_PATH/vars/terraform/examples/access_list.tfvars $BB_ORCHESTRATOR_PATH/vars/secrets/myapp-dev-use1/access_list.tfvars```
3. Edit access_list and add IPs
   1. ```vim $BB_ORCHESTRATOR_PATH/vars/secrets/myapp-dev-use1/access_list.tfvars```

## Create SSH Key for Node Group EC2 instances
Create local SSH Key that will be used to create key pair in AWS
```rake secrets:ssh_keys:create_ssh_keys_eks```

#### Init/Plan/Apply
1. ```rake init[eks_cluster]```
   1. ```1 <enter>```
2. ```rake plan[eks_cluster]```
3. ```rake apply[eks_cluster]```

#### Setup Kubectl Auth
This will make a specific file for the stack and not affect your local kubectl config
```rake kubernetes:config:replace```

#### Setup IAM Auth
IAM Authentication is granted through the OIDC setup by the eks_cluster module
1. ```rake kubernetes:config_maps:display_aws_auth_map_example```
   1. Copy Example
2. ```rake kubernetes:config_maps:edit_aws_auth```
   1. Paste Example with actual values for each IAM user to grant admin access. 

#### Test
```rake k8s_get_pods```
```rake k8s_get_nodes```
```rake k8s_get_namespaces```
```rake kubernetes:login:eks_node```
