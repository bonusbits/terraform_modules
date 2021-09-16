## CHANGE LOG
BonusBits Orchestrator

## 2.4.0 - 09/16/2021 - Levon Becker
#### Minor: Secrets Manager Secret JSON Generator
* Added aws secrets manager secrets.json generator task/lib (WIP)
* Updated docs
* Removed downcase on terraform cache path that could cause issues

## 2.3.1 - 09/09/2021 - Levon Becker
* Added aws secrets manager setup doc
* Added aws secrets manager secret example json
* Added aws secret permission policy example json
* Updated ssh key create to not include username or hostname

## 2.3.0 - 09/09/2021 - Levon Becker
#### Minor: More Modules & Role Examples
* Added New Terraform Modules
  * ec2_asg
  * efs
  * iam_user
  * s3_bucket
  * sns_topic
  * ssm_parameter
  * target_group_attach_asg
  * vpn_endpoint
* Added Example Roles
  * efs
  * iam_users
  * s3
  * vpn_endpoint

## 2.2.2 - 09/08/2021 - Levon Becker
* Added a ton more documentation
* Fixed bastion_eip and bastion_lb example rules to not include the user data chef workstation version var
* Wrote, Tested and debugged a project_setup/eks_stack.sh shell script for quick new project setup and creation in one command 
* Fixed bastion:tests:tail_cloud_init_loop. Still has debug bogus search set.
* Added two eks_apps tfvars
  * eks_app_http.tfvars
  * eks_app_https.tfvars
* Changed demo stack to use eks_app_http.tfvars so I don't have to mess with tls certs for the demo
* Fixed eks_app module to work if not passing a cert_domain_name for a none tls setup
* Split eks_apps example role into eks_apps_http and eks_apps_https
* Finally got around to better logic for loading all the rake and ruby files
* Moved project/stack/environment tasks/libs under tasks/environments folder

## 2.2.1 - 09/07/2021 - Levon Becker
* Fixed tfvar rename

## 2.2.0 - 09/07/2021 - Levon Becker
#### Minor Release: EKS + K8S
* Added EKS modules
  * eks_cluster
  * eks_fargate_profile
  * eks_fargate_role
  * eks_ingress_controller
  * eks_node_group
* Added Kubernetes modules
  * k8s_deployment
  * k8s_ingress
  * k8s_namespace
  * k8s_service
  * k8s_service_account
* Added ecr_tags module
  * Can return the latest docker image name from ECR
* Upgrade aws provider min version v3.55 > v3.57
* Added example Terraform roles for EKS
  * eks_cluster
  * eks_compute
* Added example Terraform roles for Kubernetes
  * eks_apps
  * eks_ingress_controller

## 2.1.1 - 09/07/2021 - Levon Becker
* Documentation updates to get caught up to this point

## 2.1.0 - 09/07/2021 - Levon Becker
#### Minor: EIP Bastion
* Fixed bastion/login to get eip public ip correctly in orchestrator
* Added bastion ec2 with public eip access instead of load balancer terraform role example bastion_eip

## 2.0.0 - 09/06/2021 - Levon Becker
#### Major: Refactor - Fully Functioning
* Refactored a lot
* Stripped down to only working code
  * aws_tags (dynamic solution)
  * cloudwatch_log_group
  * ec2_instance
  * eip
  * iam_instance_profile
  * key_pair
  * load_balancer
  * nat_gateway
  * security_group
  * target_group
  * target_group_attach_instance
  * vpc
* Updated to Ruby 3.x
* Updated docs
* Fixed CircleCI style testing
  * Switched from ChefDK to Chef-Workstation docker image for testing
* Added rubocop-rake tests
* Added a ton more customizations through rake config
