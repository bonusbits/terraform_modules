#### Last Updated v2.0.0 (08/25/2021)

# Orchestrator Configuration File
This article covers the syntax for the Yaml file used by the Orchestration Tool. The Orchestration Tool is wrote in Rake and Ruby.

## Naming
The yaml file must be named after the full Terraform Workspace name and in lowercase.

#### Example
**bonusbits_dev.yml**

## Path
The yaml file must be saved to the following path: ```vars/orchestrator/*.yml```

## Content
Variables are in nested groups per task/folder and namespace of the tasks.

### Kubernetes
**Not currently needed - WIP feature add**
```yaml
kubernetes:
  dashboard: 2.0.2
```
| Variable Name | Value Example | Description |
| :--- | :--- | :--- |
| dashboard           | 2.0.2   | WIP code to deploy Kubernetes Dashboard to EKS |

### Orchestrator
```yaml
orchestrator:
  environment: bonusbits
  feature_toggles:
    debug: false
    skip_all_prompts: false
    use_secrets_manager: true
```
| Variable Name | Value Example | Description |
| :--- | :--- | :--- |
| environment           | bonusbits, examples  | Working environment, used by orchestrator for conditioning |
| feature_toggles           | true/false             | Boolean variables used by orchestrator for conditioning |

### Packages
```yaml
packages:
  node: 12
  npm: 6
```
| Variable Name | Value Example | Description |
| :--- | :--- | :--- |
| node           | 12             | Major version of Nodejs to install |
| npm           | 6             | Major version of Node Package Manager to install |

### Packer
**Not currently needed**
```yaml
packer:
  image_name_prepend: bonusbits
  region_list:
    - us-east-1
    - us-east-2
    - us-west-1
    - us-west-2
```

### Terraform
```yaml
terraform:
  roles:
    - vpc
    - cloudwatch_logs
    - bastion
    - efs
    - rds_mysql
    - eks_cluster
    - eks_compute
    - eks_ingress_controller
    - eks_apps
  tfvar_roles_path: vars/terraform/bonusbits_dev
  shared_tfvar_files:
    - vars/terraform/shared/access_lists.tfvars
  s3_backend:
    bucket: bonusbits-tfs
    region: us-west-2
    key_prefix: workspaces
```
| Variable Name | Value Example | Description |
| :--- | :--- | :--- |
| roles           | ["vpc", "cloudwatch_logs", "bastion", "efs", "rds_mysql", "eks_cluster", "eks_compute", "eks_ingress_controller", "eks_apps"]             | Array/List of Terraform Roles in order of operation |
| tfvar_roles_path           | vars/terraform/bonusbits_dev           | Path from root of devops repo to where the tfvars files are for the environment |
| shared_tfvar_files           |   ["vars/terraform/bonusbits_dev/shared/certificates.tfvars", "vars/terraform/bonusbits_dev/shared/access_lists.tfvars"]              | Specific Shared tfvars files to include when calling roles |
| s3_backend | {"bucket"=>"bonusbits-tfs", "region"=>"us-west-2", "key_prefix"=>"workspaces"} | S3 bucket information where the Terraform State files are stored |

### Template Files
There are templates for each section to add to your environmental rake config.

#### vars/orchestrator/templates/bonusbits.yml
```yaml
bonusbits:
  ami_save_count: <integer>
  web_backup: <boolean>
```

#### vars/orchestrator/templates/orchestrator.yml
```yaml
orchestrator:
  environment: <string>
  feature_toggles:
    debug: <boolean>
    skip_all_prompts: <boolean>
    use_secrets_manager: <boolean>
```

#### vars/orchestrator/templates/packer.yml
```yaml
packer:
  image_name_prepend: <string>
  region_list:
    - <list of aws region to copy ami too>
```

#### vars/orchestrator/templates/terraform.yml
```yaml
terraform:
  roles:
    - <list of roles in order of operations>
  tfvar_roles_path: <path/from/root/of/repo>
  shared_tfvar_files:
    - <list of tfvar file paths from repo root to load in terraform cli>
  s3_backend:
    bucket: <s3 bucket name where terraform tfstate files are to be stored>
    region: <aws region the s3 bucket is in>
    key_prefix: <prefix folder names off root of the bucket to nest tfstate files>
```
