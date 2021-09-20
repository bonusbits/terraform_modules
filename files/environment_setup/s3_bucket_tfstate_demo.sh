#!/usr/bin/env bash

aws cloudformation create-stack --stack-name demo-tfstate-bucket \
 --profile $AWS_PROFILE \
 --region $AWS_REGION \
 --template-body file://$BB_ORCHESTRATOR_PATH/cloudformation/s3_bucket_tfstate.yml \
 --parameters ParameterKey='Owner',ParameterValue='first.last@demo.com' \
              ParameterKey='Project',ParameterValue='Terraform Backend Storage' \
              ParameterKey='DeleteAfter',ParameterValue='Never' \
              ParameterKey='BucketName',ParameterValue='demo-tfstate' \
              ParameterKey='IamUserList',ParameterValue='arn:aws:iam::************:user/********' \
              ParameterKey='PreviousLifeCycle',ParameterValue='30' \
 --tags Key='Owner',Value='first.last@demo.com' \
        Key='Project',Value='Terraform Backend Storage' \
        Key='DeleteAfter',Value='Never'

read -n 1 -s -r -p "Wait for Stack Create to Finish then Press any key to continue... "
echo ''

aws s3api put-bucket-encryption \
              --bucket demo-tfstate \
              --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

aws s3api put-object --profile $AWS_PROFILE --region $AWS_REGION --bucket demo-tfstate --key workspaces/ --server-side-encryption AES256
