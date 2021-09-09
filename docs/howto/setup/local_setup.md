#### Last Updated: 09/07/2021
# HowTo: Setup Local Workstation
These are the steps to setup your devops workstation or CI worker to use the Orchestrator Tool.

## Assumptions
* macOS 11.4+

### Local Installs
| Binary | Version |
| :--- | :--- |
| AWS CLI         | 2.2.30 |
| Chef Workstation (Ruby/Rake) | 21.7.545 (Higher or Lower may cause problems, not tested) - This gives us Ruby 3.0.2 and a ton of gems that we use. Easier than using something like RVM and installing all the gems. Easier to make sure everyone is the same version of Ruby and most gems. Plus doesn't mess with your |
| Docker      | 20.10.8 |
| Git Client      | 2.32.0 |
| JQ              | 1.6 |
| Kubectl         | 1.21.4 |
| Packer         | 1.7.4 |
| Terraform       | 1.0.5 |

### RubyGems
| Gem | Version |
| :--- | :--- |
| colorize     | 0.8.1 |
| deep_merge     | 1.2.1 |
| rubocop-rake     | 0.6.0 |

### Optional Installs
| Binary | Version |
| :--- | :--- |
| Eksctl          | 0.60.0 |
| Helm            | 3.6.3 |   

## Installs
### AWS CLI
* macOS ```brew install awscli```

### Chef Workstation
This is for Ruby and various gems that are bundled in Chef Workstation. This keeps us all on the same page and stages us for future configuration management.

1. Install Chef Workstation binary
    * macOS
        * ```brew install --cask chef-workstation```
2. Set Chef Workstation Embedded binaries
    * ```echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile```
        * Such as embedded Ruby over system Ruby
        * This way it doesn't affect your system or other Ruby environment

### Git Client
    1. macOS
        1. ```brew install git```
        2. OR Xcode Components

### Ruby Gems
* ```gem install colorize deep_merge rubocop-rake```

### Packer
* macOS
    * ```brew install packer```
    * OR
    * download and install

### Terraform
* macOS
    * ```brew install terraform```
    * OR
    * download and install

## Set Environment Variables
| Variable Name | Description |
| :--- | :--- |
| BB_ORCHESTRATOR_PATH          | Path to root of development repo |
| AWS_PROFILE                   | AWS CLI profile config profile name |
| AWS_REGION                    | AWS Region name |
| KUBECONFIG                    | i.e. /../devops/orchestrator/vars/secrets/$TF_WORKSPACE/kubectl |
| KUBE_CONFIG_PATH              | i.e. /../devops/orchestrator/vars/secrets/$TF_WORKSPACE/kubectl |
| TF_WORKSPACE                  | Terraform workspace and config names |

#### Example Bash Profile
```bash
################################################################################
# Pathing
################################################################################
export BB_ORCHESTRATOR_PATH="$HOME/Development/bonusbits/bonusbits_orchestrator"
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

################################################################################
# Chef Workstation
################################################################################
eval "$(chef shell-init bash)"

################################################################################
# Change Directory Shortcuts
################################################################################
# Orchestrator
function cd-bb-orch {
  cd $HOME/Development/bonusbits/bonusbits_orchestrator
}
cd-bb-orch

################################################################################
# Kubernetes
################################################################################
function kubeconfig-local {
    export KUBECONFIG="$HOME/.kube/config"
    export KUBE_CONFIG_PATH="${KUBECONFIG}"
}
function kubeconfig-eks {
    export KUBECONFIG="${BB_ORCHESTRATOR_PATH}/vars/secrets/${TF_WORKSPACE}/kubectl"
    export KUBE_CONFIG_PATH="${KUBECONFIG}"
}

################################################################################
# Environment Variables
################################################################################
function aws-clear(){
	unset AWS_SSH_KEY_ID AWS_SSH_KEY_PATH AWS_PROFILE AWS_DEFAULT_REGION AWS_REGION
}

function aws-env() {
	env | grep AWS_
}

function k8s-env {
  env | grep KUB
}

# KUBE_CONFIG_PATH is for Terraform Kubernetes Provider Auth to EKS
function k8s-clear(){
	unset KUBECONFIG KUBE_CONFIG_PATH
}

function clear-vars {
    aws-clear
    k8s-clear
    tf-clear
}

function tf-env() {
	env | grep TF_
}

# Don't need to clear the global cache path because it's the same for all environments
function tf-clear {
	unset TF_WORKSPACE
}

function bb-env {
  env | grep AWS_
  env | grep KUB
  env | grep BB_
  env | grep TF_
}

function bb-dev-use1 {
    clear-vars
    export AWS_PROFILE=bb
    export AWS_REGION=us-east-1
    export TF_WORKSPACE="bb-dev-use1"
    kubeconfig-eks
}

function bb-dev-usw2 {
    clear-vars
    export AWS_PROFILE=bb
    export AWS_REGION=us-west-2
    export TF_WORKSPACE="bb-dev-usw2"
    kubeconfig-eks
}

function bb-prd-usw2 {
    clear-vars
    export AWS_PROFILE=bb
    export AWS_REGION=us-west-2
    export TF_WORKSPACE="bb-prd-usw2"
    kubeconfig-eks
}
bb-dev-use1
```

## Git Repo
1. Clone bonusbits_orchestrator repo locally
    1. Clone
        1. ```git clone https://github.com/bonusbits/bonusbits_orchestrator.git```


## Version Checks
Compare your locally installed versions to the list above.
1. ```rake local_versions```
