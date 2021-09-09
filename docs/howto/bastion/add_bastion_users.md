#### Last Updated: 09/08/2021
# HowTo: Add Bastion Users

## Prerequisites
1. [Local Setup](../setup/local_setup.md)
2. [Create Terraform State File Bucket](../setup/s3_bucket_tfvars.md)
3. [Network Role](../add_terraform_roles/001_network.md)
4. [Cloudwatch Logs Role](../add_terraform_roles/002_cloudwatch_logs.md)
5. [Bastion](../add_terraform_roles/003_bastion.md)

## Add PEM Files
1. Switch to environment variables for each stack
    1. ```demo-dev-use1```
2. Create Secrets Folders if needed
   1. ```rake create_secrets_folder```
3. Add public pem for each user in a file name that will be their user name
    1. ```vim $BB_ORCHESTRATOR_PATH/vars/secrets/$TF_WORKSPACE/bastion_users/first_name.last_name```

## Create User on Bastion
4. Add Users to Bastion and Maint Team Instances
    1. ```rake bastion:users:add```
