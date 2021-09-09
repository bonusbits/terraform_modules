#!/usr/bin/env bash

function display_jq_version() {
  /usr/bin/jq --version | grep -o 'jq-[0-9]\+\.[0-9]\+' | cut -c4-
}

echo ''
echo 'INFO: JQ Version Before'
display_jq_version

echo ''
echo "INFO: Updated Apt"
sudo apt-get -q update

echo ''
echo "INFO: Install JQ"
sudo apt-get -y install jq

echo ''
echo 'INFO: JQ Version After'
display_jq_version
