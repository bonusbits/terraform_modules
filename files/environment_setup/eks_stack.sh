#!/usr/bin/env bash

# General
script_version="1.0.0"

function help_message () {
helpmessage="Description:
  Orchestrator Project Setup

Examples:
  $0 -p demo

Author:
    Levon Becker
"
  usage
  echo "$helpmessage";
}

function version_message() {
  versionmessage="Orchestrator Project Setup v$script_version"
  echo "$versionmessage";
}

function usage() {
usagemessage="Usage: $0 -p <project_name>

Options:
  -p Project Name     :  (Required) <project_name>
  -h Help             :  Displays Help Information
  -v Version          :  Displays Script Version
"
  version_message
  echo ''
  echo "$usagemessage";
}

while getopts "p:hv" opts; do
    case $opts in
        p ) project_name=$OPTARG;;
        h ) help_message; exit 0;;
        v ) version_message; exit 0;;
        * ) usage; exit 1;;
    esac
done

if [ "$project_name" = "" ]; then
    usage
    echo ''
    echo "ERROR: Missing -p project_name"
    exit 1
fi

# Roles
role_source_path="$BB_ORCHESTRATOR_PATH/terraform/environments/examples"
role_target_path="$BB_ORCHESTRATOR_PATH/terraform/environments/$project_name"
mkdir -p $role_target_path
[[ ! -d "$role_target_path/network" ]] && cp -R $role_source_path/network_nat_gateway $role_target_path
[[ -d "$role_target_path/network_nat_gateway" ]] && mv $role_target_path/network_nat_gateway $role_target_path/network
[[ ! -d "$role_target_path/cloudwatch_logs" ]] && cp -R $role_source_path/cloudwatch_logs $role_target_path
[[ ! -d "$role_target_path/bastion" ]] && cp -R $role_source_path/bastion_eip $role_target_path
[[ -d "$role_target_path/bastion_eip" ]] && mv $role_target_path/bastion_eip $role_target_path/bastion
[[ ! -d "$role_target_path/eks_cluster" ]] && cp -R $role_source_path/eks_cluster $role_target_path
[[ ! -d "$role_target_path/eks_compute" ]] && cp -R $role_source_path/eks_compute $role_target_path
[[ ! -d "$role_target_path/eks_ingress_controller" ]] && cp -R $role_source_path/eks_ingress_controller $role_target_path
[[ ! -d "$role_target_path/eks_apps" ]] && cp -R $role_source_path/eks_apps_http $role_target_path
[[ -d "$role_target_path/eks_apps_http" ]] && mv $role_target_path/eks_apps_http $role_target_path/eks_apps

# Rake Config
rake_source_path="$BB_ORCHESTRATOR_PATH/vars/orchestrator/examples"
rake_target_path="$BB_ORCHESTRATOR_PATH/vars/orchestrator"
if [ ! -f $rake_target_path/$TF_WORKSPACE.yml ]; then
  cat $rake_source_path/bastion.yml > $rake_target_path/$TF_WORKSPACE.yml
  echo '' >>  $rake_target_path/$TF_WORKSPACE.yml
  cat $rake_source_path/orchestrator.yml >> $rake_target_path/$TF_WORKSPACE.yml
  echo '' >>  $rake_target_path/$TF_WORKSPACE.yml
  cat $rake_source_path/terraform.yml >> $rake_target_path/$TF_WORKSPACE.yml
fi

# TFVars
tfv_source_path="$BB_ORCHESTRATOR_PATH/vars/terraform/examples"
tfv_target_path="$BB_ORCHESTRATOR_PATH/vars/terraform/$TF_WORKSPACE"
mkdir -p $tfv_target_path
[[ ! -f "$tfv_target_path/custom_aws_tags.tfvars" ]] && cp -R $tfv_source_path/custom_aws_tags.tfvars $tfv_target_path/custom_aws_tags.tfvars
[[ ! -f "$tfv_target_path/network.tfvars" ]] && cp -R $tfv_source_path/network_512.tfvars $tfv_target_path/network.tfvars
[[ ! -f "$tfv_target_path/cloudwatch_logs.tfvars" ]] && cp -R $tfv_source_path/cloudwatch_logs.tfvars $tfv_target_path/cloudwatch_logs.tfvars
[[ ! -f "$tfv_target_path/bastion.tfvars" ]] && cp -R $tfv_source_path/bastion_ubuntu_eip.tfvars $tfv_target_path/bastion.tfvars
[[ ! -f "$tfv_target_path/eks_cluster.tfvars" ]] && cp -R $tfv_source_path/eks_cluster.tfvars $tfv_target_path/eks_cluster.tfvars
[[ ! -f "$tfv_target_path/eks_compute.tfvars" ]] && cp -R $tfv_source_path/eks_compute_fargate.tfvars $tfv_target_path/eks_compute.tfvars
[[ ! -f "$tfv_target_path/eks_ingress_controller.tfvars" ]] && cp -R $tfv_source_path/eks_ingress_controller.tfvars $tfv_target_path/eks_ingress_controller.tfvars
[[ ! -f "$tfv_target_path/eks_apps.tfvars" ]] && cp -R $tfv_source_path/eks_apps_http.tfvars $tfv_target_path/eks_apps.tfvars

# Orchestrator
rake create_secrets_folder
rake bastion:secrets:create_ssh_key
rake secrets:ssh_keys:create_ssh_keys_eks

# Secrets
access_list_path="$BB_ORCHESTRATOR_PATH/vars/secrets/$TF_WORKSPACE/access_lists.tfvars"
[[ ! -f "$access_list_path" ]] && cp $tfv_source_path/access_lists.tfvars $access_list_path

# Git
git add $role_target_path/*
git add $tfv_target_path/*
git add $rake_target_path/*

# Edits
read -n 1 -s -r -p "Edit tfvars files and then Press any key to continue... "
echo ''

# Create
rake init
rake apply[network]
rake apply[cloudwatch_logs]
rake apply[bastion]
rake bastion:tests:instance_status_loop
rake bastion:tests:tail_cloud_init_loop
rake apply[eks_cluster]
# kubectl needed for following roles
rake kubernetes:config:replace

rake apply[eks_compute]
rake apply[eks_ingress_controller]
rake apply[eks_apps]

# Setup EKS IAM Auth
rake kubernetes:config_maps:display_aws_auth_map_example
read -n 1 -s -r -p "Press any key to continue... "
echo ''
rake kubernetes:config_maps:edit_aws_auth

# Footer

