#### Last Updated: 08/25/2021
# HowTo: Upgrade Terraform and Provider Versions
It is best to keep up with the version upgrades for feature adds, bug fixes and so the upgrade is easier. It takes about 1 hour.

Do this on any local setups and on orchestrator instances. Plus if you have multiple copies of the devops repo do it in each to update the .terraform files locally.


## Upgrade Terraform Binary
1. Update your terraform binary however you installed it on your system
   1. i.e. ```brew upgrade terraform```

## Upgrade Terraform Plugins/Providers
1. For each environment role run init upgrade
   1. ```rake init_upgrade```
2. Note any provider upgrades
   1. ```text
      Initializing provider plugins...
      - Finding hashicorp/kubernetes versions matching "~> 2.4"...
      - Finding hashicorp/null versions matching "~> 3.1"...
      - Finding hashicorp/template versions matching "~> 2.2"...
      - Finding hashicorp/aws versions matching "~> 3.53"...
      - Using previously-installed hashicorp/null v3.1.0
      - Using previously-installed hashicorp/template v2.2.0
      - Using hashicorp/aws v3.54.0 from the shared cache directory
      - Using previously-installed hashicorp/kubernetes v2.4.1
      ```
   2. So above aws plugin updated from 3.53 to 3.54

## Update Terraform Roles and Modules
Now we take that latest versions of the plugins and Terraform and set that as the minimum version allowed for our roles and modules.
1. Find/Replace Terraform version
   1. terraform/environments && terraform/modules
   2. Set in the versions.tf files
   3. i.e.
      1. ```hcl
         terraform {
           required_version        = "~> 1.0.4"
             required_providers {
               aws                   = {
               source              = "hashicorp/aws"
               version             = "~> 3.53"
             }
           }
         }
         ```
      1. ```hcl
         terraform {
           required_version        = "~> 1.0.5"
             required_providers {
               aws                   = {
               source              = "hashicorp/aws"
               version             = "~> 3.54"
             }
           }
         }
         ```
2. Update versions in [Local Setup](../setup/local_setup.md)

## Refresh all Roles
Now we need to run terraform refresh on all the roles for each stack. 
1. ```rake refresh```

## Check - Download State Files from S3
You can download the state files locally and search/check that terraform versions have been updated. EKS Annotations won't be updated until apply
1. ```rake s3d[true]```

## Run Init Upgrade Again (Optional)
It doesn't hurt to makes sure no configs got distorted and updated terraform's metadata to the newest version as the minimum.
1. ```rake init_upgrade```

## Run Plan/Apply (Optional)
It's a good idea to test out all the roles with apply. Such as, on the devops stack. To make sure there's nothing missing in the validate ran during refresh. Beware mongodb and backend_queue (not on devops) may need some size and versions tweaks to run. SO, do a plan first
1. ```rake plan```
2. Tweak tfvars as needed for mongodb etc.
3. ```rake apply```

## Version Terraform and Orchestrator Code
Even though Orchestrator didn't have changes we've tested the new Terraform code with Orchestrator so we bump the patch version.
Files:
```
README.md (URL for badge has the version)
versions.yml
terraform/README.md (URL for badge has the version)
```
