#!/usr/bin/env bash

# General
script_version="1.0.1"
download_path="/tmp"
install_path="/opt/terraform"

function help_message () {
helpmessage="Description:
  Upgrade Terraform Binary on Linux

Examples:
  Upgrade Terraform Binary to 1.0.1
  $0 -r 1.0.1

Author:
    Levon Becker
"
  usage
  echo "$helpmessage";
}

function version_message() {
  versionmessage="Terraform Upgrade v$script_version"
  echo "$versionmessage";
}

function usage() {
usagemessage="Usage: $0 -r <version>

Options:
  -r Revision         :  (Required) <terraform version number>
  -h Help             :  Displays Help Information
  -v Version          :  Displays Script Version
"
  version_message
  echo ''
  echo "$usagemessage";
}

while getopts "r:hv" opts; do
    case $opts in
        r ) terraform_version=$OPTARG;;
        h ) help_message; exit 0;;
        v ) version_message; exit 0;;
        * ) usage; exit 1;;
    esac
done

if [ "$terraform_version" = "" ]; then
    usage
    echo ''
    echo "ERROR: Missing -r terraform_version"
    exit 1
fi

function display_terraform_version() {
  /opt/terraform/terraform --version | awk '/^Terraform v[0-9]/ { print substr($2,2) }'
}

function download_terraform() {
  echo ''
  echo 'INFO: Downloading Terraform Zip'
  mkdir -p $download_path
  wget https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip -P $download_path
}

function unzip_terraform() {
  echo ''
  echo 'INFO: Unzipping Terraform'
  unzip $download_path/terraform_${terraform_version}_linux_amd64.zip -d $download_path
}

function replace_terraform_binary() {
  echo ''
  echo 'INFO: Replacing Terraform Binary'
  sudo mkdir -p $install_path
  sudo mv $download_path/terraform /opt/terraform
}

# Run
  echo ''
echo 'INFO: Terraform Version Before'
display_terraform_version
download_terraform
unzip_terraform
replace_terraform_binary
echo ''
echo 'INFO: Terraform Version After'
display_terraform_version
exit 0
