#### Last Updated v2.0.0 (08/25/2021)

# HowTo: Upgrade EKS Version In-Place
It takes about 30 minutes and does cause a brief outage.

## Prerequisites
* [Local Setup](./local_setup.md)

## Set eks.tfvars
1.20 first, then 1.21
```
eks = {
kubernetes_version            = "1.20"
```

## Terraform
1. ```rake init[eks]```
1. ```rake plan[eks]```
1. ```rake apply[eks]```

Once the cluster is updated it will look done, but then it upgrades the node group ec2 instance to new matching AMI. During this time there will be blips of interruptions to the kubernetes system namespace that lives on the Node Group.

## Upgrade Fargate Nodes
View Current Versions
```rake k8s_get_nodes```
```bash
*************************************************************************
* Kubernetes Get Nodes (verbose=false)
*************************************************************************
NAME                                    STATUS   ROLES    AGE   VERSION
fargate-ip-172-24-51-115.ec2.internal   Ready    <none>   17h   v1.19.6-eks-e91815
fargate-ip-172-24-55-140.ec2.internal   Ready    <none>   17h   v1.19.6-eks-e91815
ip-172-24-43-40.ec2.internal            Ready    <none>   46m   v1.20.4-eks-6b7464
```
To upgrade the nods new pod deployments are required. It will spin up a new fargate profile with a matching version to the cluster. 
#### Option 1 - Delete and Re-Deploy Pods
You can use a manifest and manually remove say the org deployment. Then run Terraform to re-deploy

#### Option 2 - Upgrade
During the next app upgrade process with new docker images for org it will create new pods on new matching fargate nodes.
```rake upgrade``` **with newer docker images in ECR that currently deployed**


## Set eks.tfvars
Now 1.21
```
eks = {
kubernetes_version            = "1.21"
```

## Terraform
1. ```rake init[eks]```
1. ```rake plan[eks]```
1. ```rake apply[eks]```

Once the cluster is updated it will look done, but then it upgrades the node group ec2 instance to new matching AMI. During this time there will be blips of interruptions to the kubernetes system namespace that lives on the Node Group.

Last Updated v2.0.0 (08/25/2021)
