#!/usr/bin/env bash

# Run from this directory

echo ''
echo "INFO: Install AWS CLI"
./awscli_install_upgrade_linux.sh

echo ''
echo "INFO: Install Chefws"
./chefws_install_upgrade_ubuntu.sh -r 21.7.545

echo ''
echo "INFO: Install Docker"
./docker_install_ubuntu.sh

echo ''
echo "INFO: Install Helm"
./helm_install_ubuntu.sh

echo ''
echo "INFO: Install JQ"
./jq_install_ubuntu.sh

echo ''
echo "INFO: Install Kubectl"
./kubectl_install_ubuntu.sh

echo ''
echo "INFO: Install Packer"
./packer_install_ubuntu.sh

echo ''
echo "INFO: Install Terraform"
./terraform_install_upgrade_linux.sh -r 1.0.5
