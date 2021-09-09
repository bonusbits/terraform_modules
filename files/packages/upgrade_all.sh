#!/usr/bin/env bash

# Run from this directory

echo ''
echo "INFO: Upgrade AWS CLI"
./awscli_install_upgrade_linux.sh

#echo ''
#echo "INFO: Upgrade Chefws"
#./chefws_install_upgrade_ubuntu.sh -r 21.7.545

echo ''
echo "INFO: Upgrade Docker"
./docker_upgrade_ubuntu.sh

echo ''
echo "INFO: Upgrade Helm"
./helm_upgrade_ubuntu.sh

echo ''
echo "INFO: Upgrade JQ"
./jq_upgrade_ubuntu.sh

echo ''
echo "INFO: Upgrade Kubectl"
./kubectl_upgrade_ubuntu.sh

echo ''
echo "INFO: Upgrade Packer"
./packer_upgrade_ubuntu.sh

#echo ''
#echo "INFO: Upgrade Terraform"
#./terraform_install_upgrade_linux.sh -r 1.0.5
