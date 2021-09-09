#!/usr/bin/env bash

function display_docker_version() {
  /usr/bin/docker --version | awk '{print $3}' | tr -d ','
}

echo ''
echo 'INFO: Docker Version Before'
display_docker_version

echo ''
echo "INFO: Remove Old Repo Sourced Docker"
sudo apt-get -y remove docker docker-engine docker.io containerd runc

echo ''
echo "INFO: Updated Apt"
sudo apt-get -q update

echo ''
echo "INFO: Install Dependency Packages"
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release

echo ''
echo "INFO: Add GPG Key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo ''
echo "INFO: Add Repo"
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo ''
echo "INFO: Updated Apt"
sudo apt-get -q update

echo ''
echo "INFO: Install Docker"
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

echo ''
echo 'INFO: Docker Version After'
display_docker_version
