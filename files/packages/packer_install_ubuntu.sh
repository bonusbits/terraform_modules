#!/usr/bin/env bash

function display_packer_version() {
  /usr/bin/packer -v
}

echo ''
echo 'INFO: Packer Version Before'
display_packer_version

echo ''
echo "INFO: Add Official GPG Key"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

echo ''
echo "INFO: Add Repo"
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

echo ''
echo "INFO: Updated Apt"
sudo apt-get -q update

echo ''
echo "INFO: Install JQ"
sudo apt-get -y install packer

echo ''
echo 'INFO: Packer Version After'
display_packer_version
