## CHANGE LOG
BonusBits Orchestrator

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
