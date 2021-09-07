#### Last Updated v2.2.0 (09/07/2021)
# HowTo: Add EKS Apps
Can be used spin up numerous pods with LB frontend. This one may need some customizations to fit your needs. It's setup for creating web frontend behind load balancer.

## Prerequisites
1. [Local Setup](../setup/local_setup.md)
2. [Create Terraform State File Bucket](../setup/s3_bucket_tfvars.md)
3. [Network Role](../add_terraform_roles/001_network.md)
4. [Cloudwatch Logs Role](../add_terraform_roles/002_cloudwatch_logs.md)
5. [EKS Cluster](../add_terraform_roles/005_eks_cluster.md)
6. [EKS Compute](../add_terraform_roles/006_eks_compute.md)
7. [EKS Ingress Controller](../add_terraform_roles/007_eks_ingress_controller.md)

## New Environment Example Values
* Environment: my_app
* TF Workspace: myapp-dev-use1
* TFVars Bucket: myapp-tfv
* TFVars Bucket Region: us-east-1
* Stack Region: us-east-1
* EKS Cluster Name: myapp-dev-use1

## EKS Apps Role
Now we copy and customize the example eks_ingress_controller role to our environment
#### Terraform Role
Copy example role to environment folder/s. i.e. bonusbits
```cp -R $BB_ORCHESTRATOR_PATH/terraform/environments/examples/eks_apps $BB_ORCHESTRATOR_PATH/terraform/environments/my_app/eks_apps```

#### TFVars File
1. Copy example eks_cluster.tfvars file to our environment folder/s. i.e. myapp-dev-use1
```cp -R $BB_ORCHESTRATOR_PATH/vars/terraform/examples/eks_apps.tfvars $BB_ORCHESTRATOR_PATH/vars/terraform/myapp-dev-use1/eks_apps.tfvars```
2. Edit tfvars as needed

#### Rake Config
Add the new role to the rake config. Without the inline arrows comment...
```yaml
terraform:
  roles:
    - network
    - cloudwatch_logs
    - bastion
    - eks_cluster
    - eks_compute
    - eks_ingress_controller
    - eks_apps # <<
  tfvar_roles_path: vars/terraform/myapp-dev-use1
  shared_tfvar_files:
     - vars/secrets/myapp-shared/access_lists.tfvars
  s3_backend:
     bucket: myapp-tfv
     region: us-east-1
     key_prefix: workspaces
```

#### Init/Plan/Apply
1. ```rake init[eks_apps]```
    1. ```1 <enter>```
2. ```rake plan[eks_apps]```
3. ```rake apply[eks_apps]```
