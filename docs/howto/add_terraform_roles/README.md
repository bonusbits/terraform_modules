# HowTo: Add Terraform Roles
I have named the files in the general order of operation to help. These roles plus the tfvars are were we do our customizations. Leaving the Terraform modules to stay generic. So conditioning, user data generation, policy generation, module iterations (for_each) etc is done in the roles.

#### List of Example Roles
Pick and chose from the example roles and add to your environment in the correct order. These are listed in the order of operation. So start with network.
* [Network](../add_terraform_roles/001_network.md)
* [Cloudwatch Log Groups](../add_terraform_roles/002_cloudwatch_logs.md)
* [Bastion](../add_terraform_roles/003_bastion.md)
