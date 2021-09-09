#!/usr/bin/env bash

function display_helm_version() {
  /snap/bin/helm version | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | cut -c2-
}

echo ''
echo 'INFO: Helm Version Before'
display_helm_version

echo ''
echo "INFO: Upgrade helm snap"
sudo snap refresh helm

echo ''
echo 'INFO: Helm Version After'
display_helm_version
