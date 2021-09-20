#### Last Updated: 09/20/2021
# HowTo: Create S3 Bucket for Terraform State Files
Either use the CloudFormation template in the repo or manually create an S3 bucket for the .tfstate files to be stored. Terraform can't be used to create it unless we kept the state file local which is not preferred for shared infrastructures. 

## CloudFormation (Option 1)
[CloudFormation Template](../../../cloudformation/s3_bucket_tfstate.yml)
This template enables versioning and server side encryption for a single bucket to store all of our Terraform state files

#### Set Environment Variables
* AWS_PROFILE=<profile_name>
* AWS_REGION=us-east-1


#### Create Stack
First edit the values below then run it. 
```bash
aws cloudformation create-stack --stack-name demo-tfstate-bucket \
 --profile $AWS_PROFILE \
 --region $AWS_REGION \
 --template-body file://$BB_ORCHESTRATOR_PATH/cloudformation/s3_bucket_tfstate.yml \
 --parameters ParameterKey='Owner',ParameterValue='first.last@mydomain.com' \
              ParameterKey='Project',ParameterValue='Terraform Backend Storage' \
              ParameterKey='DeleteAfter',ParameterValue='Never' \
              ParameterKey='BucketName',ParameterValue='demo-tfstate' \
              ParameterKey='IamUserList',ParameterValue='arn:aws:iam::<************>:user/<username>,arn:aws:iam::<************>:user/<username>' \
              ParameterKey='PreviousLifeCycle',ParameterValue='30' \
 --tags Key='Owner',Value='first.last@mydomain.com' \
        Key='Project',Value='Terraform Backend Storage' \
        Key='DeleteAfter',Value='Never'
```

#### Setup Bucket Encryption Default
```bash
aws s3api put-bucket-encryption \
              --bucket demo-tfstate \
              --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
```

#### Create Workspaces Folder
Create a root folder named **workspaces**
```aws s3api put-object --profile $AWS_PROFILE --region $AWS_REGION --bucket demo-tfstate --key workspaces/ --server-side-encryption AES256```


## Manually (Option 2)
It's a race condition to easily automate. We could just use a CloudFormation template to create the bucket, but I'll skip that and just give the basic manual setup.
1. Login to AWS Console
2. Open S3 console
3. Create Bucket

#### Permissions
1. Disable public access
2. Enable Versioning
3. Force Encryption with deny statements
4. Add IAM user access as needed. Could be a shared automation account, single user or list of users.
```json
{
    "Version": "2012-10-17",
    "Id": "<bucket name>-bucket-policy",
    "Statement": [
        {
            "Sid": "DenyIncorrectEncryptionHeader",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::awsexamplebucket1/*",
            "Condition": {
              "StringNotEquals": {
                "s3:x-amz-server-side-encryption": "AES256"
              }
            }
        },
        {
            "Sid": "DenyUnencryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::awsexamplebucket1/*",
            "Condition": {
              "Null": {
                "s3:x-amz-server-side-encryption": "true"
              }
            }
        },
        {
            "Sid": "Full Access for <username> User",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<************>:user/<username>"
            },
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::<bucket name>",
                "arn:aws:s3:::<bucket name>/workspaces/*"
            ]
        }
    ]
}
```
