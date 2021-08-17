provider "aws" {
  region = var.region
}

provider "aws" {
  alias = "assume_role"
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/OrganizationAccountAccessRole"
  }
}

data "sysdig_secure_trusted_cloud_identity" "trusted_sysdig_role" {
  cloud_provider = "aws"
}

data "aws_iam_policy_document" "trust_relationship" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        data.sysdig_secure_trusted_cloud_identity.trusted_sysdig_role.identity]
    }
    condition {
      test = "StringEquals"
      variable = "sts:ExternalId"
      values = [
        sysdig_secure_cloud_account.cloud_account.external_id]
    }
  }
}

data "aws_iam_policy" "SecurityAudit" {
  arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "sysdig_secure_cloud_account" "cloud_account" {
  account_id = var.account_id
  cloud_provider = "aws"
  role_enabled = "true"
}

resource "aws_iam_role" "cloudbench_role" {
  // If non-organizational, use the default provider.
  // If organizational, and this account is the master account, use the default provider
  // If organizational, and this account is a member account, use the provider with the assumed role in the member account
  provider = var.is_organizational ? (var.organizational_account_id == var.account_id ? aws : aws.assume_role) : aws

  name = "SysdigCloudBench"
  assume_role_policy = data.aws_iam_policy_document.trust_relationship.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cloudbench_security_audit" {
  // If non-organizational, use the default provider.
  // If organizational, and this account is the master account, use the default provider
  // If organizational, and this account is a member account, use the provider with the assumed role in the member account
  provider = var.is_organizational ? (var.organizational_account_id == var.account_id ? aws : aws.assume_role) : aws

  role = aws_iam_role.cloudbench_role.id
  policy_arn = data.aws_iam_policy.SecurityAudit.arn
}
