#!/usr/bin/env bash

function display_docker_version() {
  /usr/bin/docker --version | awk '{print $3}' | tr -d ','
}

echo ''
echo 'INFO: Docker Version Before'
display_docker_version

echo ''
echo "INFO: Updated Apt"
sudo apt-get -q update

echo ''
echo "INFO: Upgrade Docker"
sudo apt-get -y --only-upgrade install docker-ce docker-ce-cli containerd.io

echo ''
echo 'INFO: Apt Auto Remove'
sudo apt-get -y autoremove

echo ''
echo 'INFO: Docker Version After'
display_docker_version
