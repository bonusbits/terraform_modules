#!/usr/bin/env bash

# General
script_version="1.0.0"
download_path="/tmp"

function help_message () {
helpmessage="Description:
  Upgrade Chef Workstation Binary on Orchestrator Instance

Examples:
  Upgrade Chef Workstation Binary to 21.4.365
  $0 -r 21.4.365

Author:
    Levon Becker
"
  usage
  echo "$helpmessage";
}

function version_message() {
  versionmessage="ChefWS Upgrade v$script_version"
  echo "$versionmessage";
}

function usage() {
usagemessage="Usage: $0 -r <version>

Options:
  -r Revision         :  (Required) <chefws version number>
  -h Help             :  Displays Help Information
  -v Version          :  Displays Script Version
"
  version_message
  echo ''
  echo "$usagemessage";
}

while getopts "r:hv" opts; do
    case $opts in
        r ) chefws_version=$OPTARG;;
        h ) help_message; exit 0;;
        v ) version_message; exit 0;;
        * ) usage; exit 1;;
    esac
done

if [ "$chefws_version" = "" ]; then
    usage
    echo ''
    echo "ERROR: Missing -r chefws_version"
    exit 1
fi

function display_chefws_version() {
  cat /opt/chef-workstation/version-manifest.json | jq '.build_version' | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+'
}

function download_chefws() {
  echo ''
  echo 'INFO: Downloading ChefWS Deb Package'
  mkdir -p $download_path
  wget https://packages.chef.io/files/stable/chef-workstation/${chefws_version}/ubuntu/20.04/chef-workstation_${chefws_version}-1_amd64.deb -P $download_path
}

function install_chefws() {
  echo ''
  echo 'INFO: Install/Upgrade Chef Workstation'
  sudo dpkg -i $download_path/chef-workstation_${chefws_version}-1_amd64.deb
}

# Run
echo ''
echo 'INFO: Chef Workstation Version Before'
display_chefws_version
download_chefws
install_chefws
echo ''
echo 'INFO: Chef Workstation Version After'
display_chefws_version
exit 0
