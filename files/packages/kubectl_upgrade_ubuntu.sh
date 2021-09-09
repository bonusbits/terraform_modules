#!/usr/bin/env bash

function display_kubectl_version() {
  /snap/bin/kubectl version | grep 'Client Version' | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | cut -c2-
}

echo ''
echo 'INFO: Kubectl Version Before'
display_kubectl_version

echo ''
echo "INFO: Upgrade kubectl snap"
sudo snap refresh kubectl

echo ''
echo 'INFO: Kubectl Version After'
display_kubectl_version
