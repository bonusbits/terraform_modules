#### Last Updated: 09/08/2021
# HowTo: Add Bastion Users

## Prerequisites
1. [Local Setup](../setup/local_setup.md)
2. [Create Terraform State File Bucket](../setup/s3_bucket_tfvars.md)
3. [Network Role](../add_terraform_roles/001_network.md)
4. [Cloudwatch Logs Role](../add_terraform_roles/002_cloudwatch_logs.md)
5. [Bastion](../add_terraform_roles/003_bastion.md)

## Remove PEM Files
Remove PEM files for the users to remove
```rm $BB_ORCHESTRATOR_PATH/vars/secrets/$TF_WORKSPACE/bastion_users/first_name.last_name```

## Rebuild Bastion Host (Option 1)
```rake destroy[bastion]```
```rake apply[bastion]```

## Manually (Option 2)
1. Login to the bastion host
   1. ```rake login_bastion```
2. Remove user and Home Directory
   1. ```sudo userdel --remove firstname.lastname```
3. Remove Sudo Permissions File
   1. ```sudo rm -f /etc/sudoers.d/100-firstname-lastname```
