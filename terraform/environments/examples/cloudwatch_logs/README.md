## AWS Cloudwatch Logs Role
Separate role so if say want to destroy and re-create a role you don't delete all the log histories. Some of the groups are put in place before an automated creation like eks or vpn_endpoint so we can control the retention of the log group.

## Objects Created
* Cloudwatch Log Groups with Retention Setting
