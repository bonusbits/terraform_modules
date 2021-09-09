## AWS EFS Role
Infrastructure orchestration for the EFS mounts. Has to be after network role because there currently is no depends_on for modules and EFS module blows up on plan before subnets are created and it doesn't know how many there will be for the for_each loop.

## Objects Created
* EFS