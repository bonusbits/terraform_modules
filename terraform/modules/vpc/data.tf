data "aws_region" "current" {}

# List all AZs - Used to Get Total Count of AZs in Region
data "aws_availability_zones" "all" {}

# Get AZ Objects to be Setup Only (Has more information about each AZ including name_suffix value)
data "aws_availability_zone" "setup_azs" {
  count                       = local.setup_az_count
  name                        = data.aws_availability_zones.all.names[count.index]
}

data "aws_vpc_endpoint_service" "s3" {
  service                     = "s3"
  service_type                = "Gateway"
}
