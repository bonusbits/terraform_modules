#### Last Updated: 08/25/2021
# HowTo: Use Bonus Bits Orchestrator

## Prerequisites
* [Local Setup](./local_setup.md)
* [Create Terraform State Files Bucket](./s3_bucket_tfstate.md)

### Display Current Orchestrator Environment
```bash
rake env
```

### Display Built Stack Info
```bash
rake info
```

### List All Rake Tasks
[Rake Task List](../../reference/rake_task_list.md)

```bash
rake -T
```

### Search for a Rake Task by Name
```bash
rake -T <part of task name>
```

#### Examples
```bash
rake -T terraform
```

```bash
rake -T k8s
```

```bash
rake -T packer
```

### Bastion
If setup a bastion ec2 instance here are a few tasks specific to bastion.

#### List all Bastion Tasks
```bash
rake -T bastion
```

#### Login (SSH)
```bash
rake login_bastion
```

#### Stop Instance
```bash
rake stop_bastion
```

#### Start Instance
```bash
rake start_bastion
```

Additional Examples [here](../../reference/addtional_usage_examples.md)
