#### Last Updated: 09/09/2021
# HowTo: Create AWS Secrets Manager Secret
Add secrets to a single json file that will be used as a plaintext secret after generating our SSH Keys.

## Prerequisites
1. [Local Setup](../setup/local_setup.md)

## Generate SSH Key
```rake bastion:secrets:create_ssh_key```
```rake secrets:ssh_keys:create_ssh_keys_eks```

## Make secret value json file
1. Copy format example json
   1. ```cp $BB_ORCHESTRATOR_PATH/vars/orchestrator/examples/secrets_manager_secret.json $BB_ORCHESTRATOR_PATH/vars/secrets/$TF_WORKSPACE/secrets.json```
2. Replace public/private keys in the json
   1. Convert PEM to json
      1. ```ruby -e 'p ARGF.read' $BB_ORCHESTRATOR_PATH/vars/secrets/$TF_WORKSPACE/bastion```
      1. ```ruby -e 'p ARGF.read' $BB_ORCHESTRATOR_PATH/vars/secrets/$TF_WORKSPACE/bastion.pub```
      1. ```ruby -e 'p ARGF.read' $BB_ORCHESTRATOR_PATH/vars/secrets/$TF_WORKSPACE/eks```
      1. ```ruby -e 'p ARGF.read' $BB_ORCHESTRATOR_PATH/vars/secrets/$TF_WORKSPACE/eks.pub```
