#### Last Updated: 09/08/2021
# HowTo: Create Custom Orchestrator Environment Tasks

## Prerequisites
1. [Local Setup](../setup/local_setup.md)
2. [Create Terraform State File Bucket](../setup/s3_bucket_tfstate.md)

## Example
New Project Named: myapp

## Create Project Folder
1. Copy the demo folder and rename to project
   1. ```cp -R $BB_ORCHESTRATOR_PATH/tasks/environments/demo $BB_ORCHESTRATOR_PATH/tasks/environments/myapp```
2. Find / Replace demo with project name
   1. demo > myapp
   2. Demo > MyApp

## Edit Tasks and Libraries
Now customize your project tasks under it's own namespace
