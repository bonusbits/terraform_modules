#!/usr/bin/env bash

function display_awscli_version() {
  /usr/local/bin/aws --version | grep -o 'aws-cli\/[0-9]\+\.[0-9]\+\.[0-9]\+' | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+'
}

echo ''
echo 'INFO: AWS CLI Version Before'
display_awscli_version

echo ''
echo "INFO: Cleanup v1.x"
[[ -d "/tmp/awscli-bundle" ]] && sudo rm -rf /tmp/awscli-bundle
[[ -a "/tmp/awscli-bundle.zip" ]] && sudo rm -rf /tmp/awscli-bundle.zip

echo ''
echo "INFO: Download AWS CLI 2.x Zip"
download_retries=1
until [ ${download_retries} -ge 6 ]; do
    echo "INFO: Attempt (${download_retries})"
    [[ -a "/tmp/awscliv2.zip" ]] && sudo rm -f /tmp/awscliv2.zip
    sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && break
    download_retries=$[$download_retries+1]
    echo "ERROR: Sleeping 10..."
    sleep 10
done

echo ''
echo "INFO: Unzip AWS CLI 2.x Bundle"
unzip_retries=1
until [ ${unzip_retries} -ge 6 ]; do
    echo "INFO: Attempt (${unzip_retries})"
    [[ -d "/tmp/aws" ]] && sudo rm -rf /tmp/aws
    sudo unzip -oq /tmp/awscliv2.zip -d /tmp && break
    unzip_retries=$[$unzip_retries+1]
    echo "ERROR: Sleeping 10..."
    sleep 10
done

echo ''
echo "INFO: Remove Old Install"
sudo rm -f /usr/local/bin/aws
sudo rm -f /usr/local/aws-cli
sudo rm -f /usr/local/bin/aws_completer
sudo rm -rf /usr/local/aws
sudo rm -f /usr/bin/aws

echo ''
echo "INFO: Install/Upgrade AWS CLI 2.x Bundle"
install_retries=1
until [ ${install_retries} -ge 6 ]; do
    echo "INFO: Attempt (${install_retries})"
    sudo /tmp/aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws --update && break
    install_retries=$[$install_retries+1]
    echo "ERROR: Sleeping 10..."
    sleep 10
done

echo ''
echo 'INFO: AWS CLI Version After'
display_awscli_version
