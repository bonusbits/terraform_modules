## AWS VPN
Setup client VPN (Not Deployed)

## Objects Created
* Client VPN Endpoints

## To Destroy Role
There is a bug where Terraform does not disassociate client VPN target Networks correctly. So, if you are destroying the whole setup. You need to first manually disassociate the 3 networks.
1. Login to AWS console
1. Browse to VPC section > Client VPN Endpoint
1. Select Client VPN Endpoint (gs-p1-use2)
1. Select sub-tab **Associations**
1. Select one at a time and select **Disassociate**
1. Wait for it to finish
    1. Takes 10-15 minutes
    1. They will disappear from the list
1. Then run ```rake destroy[vpn]```
