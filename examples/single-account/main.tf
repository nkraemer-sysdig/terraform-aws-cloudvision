provider "aws" {
  region = var.region
}

provider "sysdig" {
  sysdig_secure_url       = var.sysdig_secure_endpoint
  sysdig_secure_api_token = var.sysdig_secure_api_token
}

module "cloudvision" {
  source = "../../"

  providers = {
    aws.cloudvision = aws
  }
  name = var.name

  sysdig_secure_endpoint  = var.sysdig_secure_endpoint
  sysdig_secure_api_token = var.sysdig_secure_api_token

  #  testing purpose; economization
  cloudtrail_is_multi_region_trail = var.cloudtrail_is_multi_region_trail
  cloudtrail_kms_enable            = var.cloudtrail_kms_enable

  tags = var.tags
}
