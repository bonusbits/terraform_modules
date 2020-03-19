#### Last Updated v2.0.0 (09/02/2021)


## Rake Task Aliases
| Task | Description |
| :--- | :--- |
| apply[role]                                                            | Alias (terraform:apply[item])
| bb_info                                                                | Alias (bonusbits:info:summary)
| bb_info_network                                                        | Alias (bonusbits:info:network)
| create_ami_bastion                                                     | Alias (bastion:ec2:create_ami)
| create_secrets_folder                                                  | Alias (secrets:folders:create_secrets_folders)
| default                                                                | Alias (test:style:ruby:auto_correct)
| destroy[role]                                                          | Alias (terraform:destroy[role])
| destroy_target[role,target]                                            | Alias (terraform:destroy_target[role,target])
| down                                                                   | Alias (bonusbits:destroy:stack)
| env                                                                    | Alias (orchestrator:debug:env)
| get_secrets[overwrite]                                                 | Alias (secrets:secrets_manager:get_secrets)
| helm_list_charts[repo]                                                 | Alias (helm:repos:list_charts[repo])
| helm_update_repos                                                      | Alias (helm:repos:update)
| import[role,filename]                                                  | Alias (terraform:import[role,filename])
| init[role]                                                             | Alias (terraform:init[role])
| init_reconfigure[role]                                                 | Alias (terraform:init_reconfigure[role])
| init_upgrade[role]                                                     | Alias (terraform:init_upgrade[role])
| k8s_desc_configmap[namespace,name]                                     | Alias (kubernetes:config_maps:describe_config_map[namespace,role_name])
| k8s_desc_configmap_awsauth                                             | Alias (kubernetes:config_maps:describe_config_map[kube-system,aws-auth])
| k8s_desc_custom_resource[name]                                         | Alias (kubernetes:custom_resources:describe[name])
| k8s_desc_deployment[namespace,deployment_name]                         | Alias (kubernetes:deployments:describe_deployment[namespace,deployment_name])
| k8s_desc_ingress[namespace,ingress_name]                               | Alias (kubernetes:ingress:describe_ingress[namespace,ingress_name])
| k8s_desc_job[namespace,job_name]                                       | Alias (kubernetes:jobs:describe_job[namespace,job_name])
| k8s_desc_namespace[name]                                               | Alias (kubernetes:namespaces:describe[name])
| k8s_desc_node[node_name]                                               | Alias (kubernetes:nodes:describe_node[node_name])
| k8s_desc_pod[namespace,pod_name]                                       | Alias (kubernetes:pods:describe_pod[namespace,pod_name])
| k8s_desc_role[namespace,role_name]                                     | Alias (kubernetes:roles:describe_role[namespace,role_name])
| k8s_desc_service[namespace,service_name]                               | Alias (kubernetes:services:describe_service[namespace,service_name])
| k8s_desc_service_account[namespace,service_name]                       | Alias (kubernetes:service_accounts:describe[namespace,service_name])
| k8s_desc_target_group_binding[namespace,name]                          | Alias (kubernetes:target_group_bindings:describe[namespace,service_name])
| k8s_edit_configmap_awsauth                                             | Alias (kubernetes:config_maps:edit_aws_auth)
| k8s_get_configmaps[namespace,verbose]                                  | Alias (kubernetes:config_maps:get_config_maps[namespace])
| k8s_get_custom_resources                                               | Alias (kubernetes:custom_resources:get[namespace])
| k8s_get_deployments[namespace,verbose]                                 | Alias (kubernetes:deployments:get_services[namespace])
| k8s_get_ingresses[namespace,verbose]                                   | Alias (kubernetes:ingress:get_ingresses[namespace])
| k8s_get_jobs[namespace,verbose]                                        | Alias (kubernetes:jobs:get_jobs[namespace])
| k8s_get_namespaces                                                     | Alias (kubernetes:namespaces:get)
| k8s_get_nodes[verbose]                                                 | Alias (kubernetes:nodes:get_nodes[verbose])
| k8s_get_pods[namespace,verbose]                                        | Alias (kubernetes:pods:get_pods[namespace])
| k8s_get_roles[namespace,verbose]                                       | Alias (kubernetes:roles:get_roles[namespace])
| k8s_get_service_accounts[namespace,verbose]                            | Alias (kubernetes:service_accounts:get[namespace])
| k8s_get_services[namespace,verbose]                                    | Alias (kubernetes:services:get_services[namespace])
| k8s_get_target_group_bindings[namespace,verbose]                       | Alias (kubernetes:target_group_bindings:get[namespace,verbose])
| k8s_logs[namespace,deployment_name,follow]                             | Alias (kubernetes:logs:deployment[namespace,deployment_name])
| k8s_logs_cert_manager                                                  | Alias (kubernetes:logs:deployment[cert-manager,deployment.app/cert-manager])
| k8s_logs_cert_manager_f                                                | Alias (kubernetes:logs:deployment[cert-manager,deployment.app/cert-manager])
| k8s_logs_ingress_controller                                            | Alias (kubernetes:logs:deployment[kube-system,deployment.apps/aws-load-balancer-controller])
| k8s_logs_ingress_controller_f                                          | Alias (kubernetes:logs:deployment[kube-system,deployment.apps/aws-load-balancer-controller])
| k8s_status_loop[namespace,pod_name]                                    | Alias (kubernetes:pods:status_loop[namespace,pod_name])
| k8s_status_pod[namespace,pod_name]                                     | Alias (kubernetes:pods:status_pod[namespace,pod_name])
| kube_config_contexts                                                   | Alias (kubernetes:config:get_contexts)
| local_env                                                              | Alias (orchestrator:local:show_local_versions)
| local_versions                                                         | Alias (orchestrator:local:show_local_versions)
| login_bastion                                                          | Alias (bastion:login:direct)
| login_eks_node                                                         | Alias (kubernetes:login:eks_node)
| login_private_ip[ip,ssh_key,user_name]                                 | Alias (bastion:login:proxy_ip[ip,ssh_key,username])
| pkr_build[image,role]                                                  | Alias (packer:build:ami[image,role]) - rake pkr_build[ubuntu_1804,web]
| pkr_cleanup[image,ami_save_count]                                      | Alias (packer:cleanup:remove_old_images[name,ami_save_count]) - rake pkr_cleanup[bastion,2]
| pkr_init[image,role]                                                   | Alias (packer:init[image,role]) - rake pkr_init[ubuntu_1804,bastion]
| pkr_inspect[image,role]                                                | Alias (packer:inspect[image,role]) - rake pkr_inspect[ubuntu_1804,bastion]
| pkr_validate[image,role]                                               | Alias (packer:validate[image,role]) - rake pkr_validate[ubuntu_1804,bastion]
| plan[role]                                                             | Alias (terraform:plan[role])
| refresh[role]                                                          | Alias (terraform:refresh[item])
| s3d[force]                                                             | Alias (aws:s3:download_state_files[force])
| s3download[force]                                                      | Alias (aws:s3:download_state_files[force])
| s3u[role]                                                              | Alias (aws:s3:upload_state_file[item])
| s3upload[role]                                                         | Alias (aws:s3:upload_state_file[item])
| show_import_vars                                                       | Alias (terraform:debug:show_import_vars)
| show_packer_common_vars                                                | Alias (packer:debug:show_common_vars)
| show_terraform_common_vars                                             | Alias (terraform:debug:show_common_vars)
| show_vars                                                              | Alias (orchestrator:debug:show_vars)
| start_bastion                                                          | Alias (bastion:ec2:start_instance)
| state_list[role]                                                       | Alias (terraform:state:list[role])
| state_move[role,source,destination]                                    | Alias (terraform:state:move[role,source,destination])
| state_remove[role,address]                                             | Alias (terraform:state:remove[role,address])
| stop_bastion                                                           | Alias (bastion:ec2:stop_instance)
| test_style                                                             | Alias (test:style:ruby)
| up                                                                     | Alias (bonusbits:deploy:stack)
| upgrade                                                                | Alias (bonusbits:upgrade:stack)
| upload_secrets                                                         | Alias (secrets:secrets_manager:upload_secrets)

# Rake Task List
| Task | Description |
| :--- | :--- |
| aws:alb:check_target_healthy_app                                       | Check All App ALB Target Groups Until First Instance is Healthy                                 |
| aws:alb:check_target_healthy_k8s                                       | Check All K8S ALB Target Groups Until First Instance is Healthy                                 |
| aws:ec2:latest_ami_id[name]                                            | Get Latest AMI ID - rake aws:ec2:latest_ami_id[bastion]                                         |
| aws:ec2:remove_old_instance_images[instance_name,ami_save_count]       | Remove Single Specific Instance Name Old Images                                                 |
| aws:iam:current_user_account_id                                        | Current AWS Account ID                                                                          |
| aws:iam:current_user_arn                                               | Current IAM User ARN                                                                            |
| aws:s3:download_state_files[force]                                     | Download all Terraform State Files from S3                                                      |
| aws:s3:upload_all_state_files                                          | Upload all Terraform State File to S3                                                           |
| aws:s3:upload_state_file[role]                                         | Upload a Single Terraform State File to S3 - (rake aws:s3:upload_state_file[bastion])           |
| aws:secrets_manager:display_secret[secret_name]                        | Get Secret                                                                                      |
| aws:vpn:create_client_certs[username]                                  | Create and Import Client Certs                                                                  |
| aws:vpn:create_client_config[username]                                 | Create Client Config                                                                            |
| aws:vpn:create_server_certificates                                     | Create Server and Client Certificates for VPN Endpoint Locally                                  |
| aws:vpn:stage_easy_rsa                                                 | Stage Easy RSA                                                                                  |
| aws:vpn:upload_server_certificates                                     | Upload Server and Client Certificates to ACM for VPN Endpoint                                   |
| bastion:ec2:create_ami                                                 | Create Bastion Instance Image                                                                   |
| bastion:ec2:remove_old_ami[ami_save_count]                             | Remove Old Bastion Images                                                                       |
| bastion:ec2:start_instance                                             | Start Bastion Instances                                                                         |
| bastion:ec2:stop_instance                                              | Stop Bastion Instances                                                                          |
| bastion:login:direct                                                   | Login to Bastion Host                                                                           |
| bastion:login:proxy_instance[type,instance_name]                       | Login to Private Via Bastion  - (rake bastion:login:proxy_instance[web])                        |
| bastion:login:proxy_ip[ip,ssh_key,user_name]                           | Login to Private IP Via Bastion  - (rake bastion:login:proxy_ip[172.25.32.105,eks,ec2-user])    |
| bastion:secrets:create_ssh_key                                         | Generate Bastion EC2 Instance SSH Keypair that Terraform Can Upload to AWS                      |
| bastion:tail_cloud_init                                                | Tail Cloud Init Output on Bastion                                                               |
| bastion:users:add                                                      | Add Users to Bastion Host                                                                       |
| bonusbits:deploy:stack                                                 | Create Entire Stack with Terraform (Based on Env Vars)                                          |
| bonusbits:destroy:stack                                                | Delete Entire Stack with Terraform (Based on Env Vars)                                          |
| bonusbits:info:network                                                 | Display Network Info                                                                            |
| bonusbits:info:summary                                                 | Display Stack Summary                                                                           |
| bonusbits:upgrade:stack                                                | Upgrade the Bonus Bits Web App Services                                                         |
| helm:repos:add_eks_charts                                              | Add EKS Charts                                                                                  |
| helm:repos:list_charts[repo]                                           | List Repos Charts                                                                               |
| helm:repos:remove_eks_charts                                           | Remove EKS Charts                                                                               |
| helm:repos:update                                                      | Update Helm Repos                                                                               |
| kubernetes:config:get_clusters                                         | Display Kubectl Config Clusters (Local)                                                         |
| kubernetes:config:get_contexts                                         | Display Kubectl Config Contexts (Local)                                                         |
| kubernetes:config:replace                                              | Replace Kubectl Config                                                                          |
| kubernetes:config:update                                               | Update Kubectl Config (Append)                                                                  |
| kubernetes:config:view                                                 | Display Kubectl Config                                                                          |
| kubernetes:config_maps:add_aws_auth                                    | Kubernetes Add AWS Auth IAM Users                                                               |
| kubernetes:config_maps:describe_config_map[namespace,name]             | Kubernetes Describe a Config Map                                                                |
| kubernetes:config_maps:display_aws_auth_map_example                    | Kubernetes Display AWS Auth User Map                                                            |
| kubernetes:config_maps:edit_aws_auth                                   | Kubernetes Edit AWS Auth Config Map                                                             |
| kubernetes:config_maps:get_config_maps[namespace,verbose]              | Kubernetes Get Config Maps                                                                      |
| kubernetes:custom_resources:describe[name]                             | Kubernetes Describe a Custom Resource                                                           |
| kubernetes:custom_resources:get                                        | Kubernetes Get Custom Resources                                                                 |
| kubernetes:deploy:check_deployment[namespace,pod_name]                 | Kubernetes Check Deployment                                                                     |
| kubernetes:deployments:describe_deployment[namespace,deployment_name]  | Kubernetes Describe a Deployment                                                                |
| kubernetes:deployments:get_deployments[namespace,verbose]              | Kubernetes Get Deployments                                                                      |
| kubernetes:ingress:describe_ingress[namespace,ingress_name]            | Kubernetes Describe an Ingress                                                                  |
| kubernetes:ingress:get_ingresses[namespace,verbose]                    | Kubernetes Get Ingress                                                                          |
| kubernetes:jobs:describe_job[namespace,job_name]                       | Kubernetes Describe a Job                                                                       |
| kubernetes:jobs:get_jobs[namespace,verbose]                            | Kubernetes Get Jobs                                                                             |
| kubernetes:login:eks_node                                              | Kubernetes Login Node Group EC2 Instance                                                        |
| kubernetes:logs:deployment[namespace,deployment_name,follow]           | Kubernetes Deployment Logs                                                                      |
| kubernetes:namespaces:describe[name]                                   | Kubernetes Describe Namespace                                                                   |
| kubernetes:namespaces:get                                              | Kubernetes Namespaces                                                                           |
| kubernetes:nodes:describe_node[node_name]                              | Kubernetes Describe a Node                                                                      |
| kubernetes:nodes:get_nodes[verbose]                                    | Kubernetes Get Nodes                                                                            |
| kubernetes:nodes:node_ip                                               | Kubernetes Fetch Node IP                                                                        |
| kubernetes:pods:describe_pod[namespace,pod_name]                       | Kubernetes Describe a Pod                                                                       |
| kubernetes:pods:get_pods[namespace,verbose]                            | Kubernetes Get Pods                                                                             |
| kubernetes:pods:status_loop[namespace,pod_name]                        | Kubernetes Status of a Pod Loop                                                                 |
| kubernetes:pods:status_pod[namespace,pod_name]                         | Kubernetes Status of a Pod                                                                      |
| kubernetes:roles:describe_role[namespace,role_name]                    | Kubernetes Describe a Role                                                                      |
| kubernetes:roles:get_roles[namespace,verbose]                          | Kubernetes Get Roles                                                                            |
| kubernetes:service_accounts:describe[namespace,service_name]           | Kubernetes Describe a Service Account                                                           |
| kubernetes:service_accounts:get[namespace,verbose]                     | Kubernetes Get Service Accounts                                                                 |
| kubernetes:services:describe_service[namespace,service_name]           | Kubernetes Describe a Service                                                                   |
| kubernetes:services:get_services[namespace,verbose]                    | Kubernetes Get Services                                                                         |
| kubernetes:target_group_bindings:describe[namespace,name]              | Kubernetes Describe a Target Group Binding                                                      |
| kubernetes:target_group_bindings:get[namespace,verbose]                | Kubernetes Get Target Group Bindings                                                            |
| orchestrator:debug:env                                                 | Display Current Environment                                                                     |
| orchestrator:debug:orchestrator_version                                | Display Orchestrator Version                                                                    |
| orchestrator:debug:show_vars                                           | Show Project Rake Variables from Yaml and Environment Variables                                 |
| orchestrator:local:show_local_env_vars                                 | Display Relevant Local Environment Variables                                                    |
| orchestrator:local:show_local_versions                                 | Display Local Tool Versions                                                                     |
| packer:build:ami[image,role]                                           | Packer Build AMI (rake packer:build:ami[ubuntu_1804,backend])                                   |
| packer:cleanup:remove_old_images[instance_name,ami_save_count]         | Remove Old Images                                                                               |
| packer:debug:show_common_vars                                          | Show Packer CLI Common Vars                                                                     |
| packer:init[image,role]                                                | Run Packer Initialization - (rake packer:init[ubuntu_1804,backend])                             |
| packer:inspect[image,role]                                             | Run Packer Inspect - (rake packer:inspect[ubuntu_1804,bastion])                                 |
| packer:validate[image,role]                                            | Run Packer Validate - (rake packer:validate[ubuntu_1804,bastion])                               |
| packer:vars:local_version                                              | Display Local Packer Version                                                                    |
| secrets:folders:create_secrets_folders                                 | Create Secrets Folder Locally                                                                   |
| secrets:secrets_manager:display_value_as_hash                          | Get Stack Secrets JSON                                                                          |
| secrets:secrets_manager:display_value_as_json                          | Display Value of Devops Secret for Current Stack                                                |
| secrets:secrets_manager:get_secrets[overwrite]                         | Get TFVars Secrets and SSH Key Files and Create Locally from AWS Secrets Manager                |
| secrets:secrets_manager:upload_secrets                                 | Upload Secrets Value to AWS Secrets Manager                                                     |
| secrets:ssh_keys:convert_rsa_key_to_pem[key_name]                      | Generate RSA SSH PEM Keys that Terraform Can Upload to AWS                                      |
| secrets:ssh_keys:create_ssh_key[key_name]                              | Generate RSA SSH PEM Keys that Terraform Can Upload to AWS                                      |
| secrets:ssh_keys:create_ssh_keys_eks                                   | Generate EKS Node Group AWS SSH Keypair that Terraform Can Upload to AWS                        |
| secrets:ssh_keys:get_ssh_keys                                          | Get All SSH Keys from AWS Secrets Manager JSON Secret and Create Locally                        |
| secrets:tf_vars:get_secrets_tfvars                                     | Create TFVars Secrets Files Locally                                                             |
| terraform:apply[role]                                                  | Run Terraform Apply - (rake terraform:apply, rake terraform:apply[bastion])                     |
| terraform:console[role]                                                | Run Terraform Console                                                                           |
| terraform:debug:show_all_terraform_outputs                             | Fetch and Show Terraform Outputs                                                                |
| terraform:debug:show_all_terraform_outputs_keys                        | Fetch and Show Terraform Output Keys                                                            |
| terraform:debug:show_common_vars                                       | Show Terraform CLI Common Vars                                                                  |
| terraform:debug:show_import_var_keys                                   | Show Project Rake Terraform Import Variables from Yaml Files                                    |
| terraform:debug:show_import_vars                                       | Show Project Rake Terraform Import Variables from Yaml Files                                    |
| terraform:debug:show_import_vars_single[map]                           | Show Project Rake Terraform Import Variables from for Single Yaml File - (rake terraform:debug:show_import_vars_single[before_split]) |
| terraform:destroy[role]                                                | Run Terraform Destroy - (rake terraform:destroy, rake terraform:destroy[bastion]) |
| terraform:destroy_target[role,target]                                  | Destroy Terraform Resource Target - (rake terraform:destroy_target[eks,module.eks_node_group.aws_eks_node_group.default]) |
| terraform:import[role,filename]                                        | Run Terraform Import - (rake terraform:import, rake terraform:import[role], rake terraform:import[role,filename]) |
| terraform:init[role]                                                   | Run Terraform Initialization - (rake terraform:init, rake terraform:init[bastion]) |
| terraform:init_migrate_state[role]                                     | Run Terraform Initialization with Migrate State - (rake terraform:init_migrate_state, rake terraform:init_migrate_state[bastion]) |
| terraform:init_reconfigure[role]                                       | Run Terraform Initialization with Reconfigure - (rake terraform:init_reconfigure, rake terraform:init_reconfigure[bastion]) |
| terraform:init_upgrade[role]                                           | Upgrade Terraform Providers - (rake terraform:init_upgrade, rake terraform:init_upgrade[network]) |
| terraform:plan[role]                                                   | Run Terraform Plan - (rake terraform:plan, rake terraform:plan[network]) |
| terraform:providers:delete_all_caches                                  | Delete Providers Caches in all Roles and Global - (rake terraform:providers:delete_all_cache) |
| terraform:providers:delete_global_cache[path]                          | Delete Providers in Global Cache - (rake terraform:providers:delete_global_cache, rake terraform:providers:delete_global_cache[path]) |
| terraform:providers:delete_role_cache[role]                            | Delete Providers in a Role - (rake terraform:providers:delete_role_cache, rake terraform:providers:delete_role_cache[role]) |
| terraform:providers:list[role]                                         | Display Terraform Providers - (rake terraform:providers[role])                                         |
| terraform:refresh[role]                                                | Refresh Terraform State - (rake terraform:refresh, rake terraform:refresh[bastion])                    |
| terraform:state:list[role]                                             | Terraform State List - (rake terraform:state:list[role])                                               |
| terraform:state:move[role,source,destination]                          | Terraform State Move - (rake terraform:state:move[role,source,destination])                            |
| terraform:state:remove[role,address]                                   | Terraform State Remove - (rake terraform:state:remove[role,address])                                   |
| terraform:validate[role]                                               | Validate Terraform Configurations                                                                      |
| terraform:vars:create_import_maps_folder                               | Create Import Maps Folder Locally                                                                      |
| terraform:vars:local_version                                           | Display Local Terraform Version                                                                        |
| terraform:workspaces                                                   | Display Terraform Workspaces                                                                           |
| test:style:ruby                                                        | RuboCop                                                                                                |
| test:style:ruby:auto_correct                                           | Auto-correct RuboCop offenses                                                                          |
| tmp:set_env_vars[role]                                                 | Set Environment Variables for a Stack - (rake tmp:set_env_vars[pobl-d2-use2])                          |
| web:status:http_code_bastion[url]                                      | Get HTTP Return Code from Bastion - rake web:status:http_code_bastion[https://www.bonusbits.com]       |
| web:status:http_code_local[url]                                        | Get HTTP Return Code Locally - rake web:status:http_code_local[https://www.bonusbits.com]              |
| web:status:http_ok_local[url]                                          | Check if HTTP OK Locally - rake web:status:http_code_local[https://www.bonusbits.com]                  |


