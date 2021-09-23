#!/usr/bin/env bash

stack_name="demo-s3-tfstate"
bucket_name="bonusbits-demo-tfstate"
owner_email="first.last@demo.com"
iam_users_arns="arn:aws:iam::************:user/********"

aws cloudformation create-stack --stack-name ${stack_name} \
 --profile $AWS_PROFILE \
 --region $AWS_REGION \
 --template-body file://$BB_ORCHESTRATOR_PATH/cloudformation/s3_bucket_tfstate.yml \
 --parameters ParameterKey='Owner',ParameterValue="${owner_email}" \
              ParameterKey='Project',ParameterValue="Terraform Backend Storage" \
              ParameterKey='DeleteAfter',ParameterValue="Never" \
              ParameterKey='BucketName',ParameterValue="${bucket_name}" \
              ParameterKey='IamUserList',ParameterValue="${iam_users_arns}" \
              ParameterKey='PreviousLifeCycle',ParameterValue='30' \
 --tags Key='Owner',Value="${owner_email}" \
        Key='Project',Value='Terraform Backend Storage' \
        Key='DeleteAfter',Value='Never'

read -n 1 -s -r -p "Wait for Stack Create to Finish then Press any key to continue... "
echo ''

aws s3api put-bucket-encryption \
              --bucket ${bucket_name} \
              --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

aws s3api put-object --profile $AWS_PROFILE --region $AWS_REGION --bucket ${bucket_name} --key workspaces/ --server-side-encryption AES256
