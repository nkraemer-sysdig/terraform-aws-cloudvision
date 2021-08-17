variable "account_id" {
  type        = string
  description = "the account_id in which to provision the cloud-bench IAM role"
}

#---------------------------------
# optionals - with default
#---------------------------------

variable "is_organizational" {
  type        = bool
  default     = false
  description = "whether cloudvision should be deployed in an organizational setup"
}

variable "organizational_account_id" {
  type        = string
  default     = null
  description = "the accountID of the organizational account. Must be set if is_organizational = true"
}

variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "Default region for resource creation in both organization master and cloudvision member account"
}

variable "tags" {
  type        = map(string)
  description = "sysdig cloudvision tags"
  default = {
    "product" = "sysdig-cloudvision"
  }
}
