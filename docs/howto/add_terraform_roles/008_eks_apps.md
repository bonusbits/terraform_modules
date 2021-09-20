#### Last Updated: 09/08/2021
# HowTo: Add EKS Apps
Can be used spin up numerous pods with LB frontend. This one may need some customizations to fit your needs. It's setup for creating web frontend behind load balancer.

## Prerequisites
1. [Local Setup](../setup/local_setup.md)
2. [Create Terraform State File Bucket](../setup/s3_bucket_tfstate.md)
3. [Network Role](./001_network.md)
4. [Cloudwatch Logs Role](./002_cloudwatch_logs.md)
5. [Bastion](./003_bastion.md)
6. [EKS Cluster](./005_eks_cluster.md)
7. [EKS Compute](./006_eks_compute.md)
8. [EKS Ingress Controller](./007_eks_ingress_controller.md)

## New Environment Example Values
* Environment: demo
* TF Workspace: demo-dev-use1
* TFVars Bucket: demo-tfv
* TFVars Bucket Region: us-east-1
* Stack Region: us-east-1
* EKS Cluster Name: demo-dev-use1

## EKS Apps Role
Now we copy and customize the example eks_ingress_controller role to our environment
#### Terraform Role
Copy example role to environment folder/s. i.e. bonusbits
```cp -R $BB_ORCHESTRATOR_PATH/terraform/environments/examples/eks_apps $BB_ORCHESTRATOR_PATH/terraform/environments/demo/eks_apps```

#### TFVars File
1. Copy example eks_cluster.tfvars file to our environment folder/s. i.e. demo-dev-use1
```cp -R $BB_ORCHESTRATOR_PATH/vars/terraform/examples/eks_apps.tfvars $BB_ORCHESTRATOR_PATH/vars/terraform/$TF_WORKSPACE/eks_apps.tfvars```
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
  tfvar_roles_path: vars/terraform/demo-dev-use1
  shared_tfvar_files:
     - vars/secrets/demo-shared/access_lists.tfvars
  s3_backend:
     bucket: demo-tfv
     region: us-east-1
     key_prefix: workspaces
```

## Wait for All Roles (Option 1)
We can wait until you have all the roles setup and then use init, plan and apply calls without specifying the role to run them all in order of how they are listed in the rake config terraform:roles array. Then complete steps below.
1. ```rake init```
   1. ```1 <enter>```
2. ```rake plan```
3. ```rake apply```

## Create Role Objects (Option 2)
1. ```rake init[eks_apps]```
    1. ```1 <enter>```
2. ```rake plan[eks_apps]```
3. ```rake apply[eks_apps]```
