## CHANGE LOG
BonusBits Orchestrator

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
#### Minor Release: EIP Bastion
* Fixed bastion/login to get eip public ip correctly in orchestrator
* Added bastion ec2 with public eip access instead of load balancer terraform role example bastion_eip

## 2.0.0 - 09/06/2021 - Levon Becker
#### Major Release: Refactor - Fully Functioning
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
