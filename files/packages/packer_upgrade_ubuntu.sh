#!/usr/bin/env bash

function display_packer_version() {
  /usr/bin/packer -v
}

echo ''
echo 'INFO: Packer Version Before'
display_packer_version

echo ''
echo "INFO: Upgrade Packer package"
sudo apt-get -q update
sudo apt-get -y --only-upgrade install packer

echo ''
echo 'INFO: Apt Auto Remove'
sudo apt-get -y autoremove

echo ''
echo 'INFO: Packer Version After'
display_packer_version
