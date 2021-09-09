#### Last Updated: 09/07/2021
# HowTo: Create S3 Bucket for Terraform State Files
Either manually create or use a CloudFormation template to create a bucket for the .tfstate files. This is a manual setup example.

## Create Bucket
It's a race condition to easily automate. We could just use a CloudFormation template to create the bucket, but I'll skip that and just give the basic manual setup.
1. Login to AWS Console
2. Open S3 console
3. Create Bucket

## Permissions
1. Disable public access
2. Add IAM user access as needed. Could be a shared automation account, single user or list of users.
```json
{
    "Version": "2012-10-17",
    "Id": "<bucket name>-bucket-policy",
    "Statement": [
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
