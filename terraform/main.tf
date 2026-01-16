provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}

data "aws_iam_role" "capability_access_role" {
  name = "CapabilityAccessFromKubernetes"
}

resource "aws_iam_policy" "rds_connect_policy" {
  name        = "${var.prefix}-rds-connect-policy"
  description = "Policy to allow RDS connectivity for capability access role"
  policy = templatefile("${path.module}/iam/policies/rds-connect.json", {
    aws_region      = var.aws_region,
    account_id      = var.account_id
    rds_resource_id = var.rds_resource_id
  })
}

resource "aws_iam_policy" "rds_discovery_policy" {
  name        = "${var.prefix}-rds-discovery-policy"
  description = "Policy to allow RDS discovery for capability access role"
  policy = templatefile("${path.module}/iam/policies/rds-discovery.json", {
    aws_region = var.aws_region,
    account_id = var.account_id
  })
}

locals {
  secretsmanager_arns = formatlist("arn:aws:secretsmanager:${var.aws_region}:${var.account_id}:secret:%s", var.secretsmanager_secret_names)
  kms_keys_arns       = formatlist("arn:aws:kms:${var.aws_region}:${var.account_id}:key/%s", var.kms_keys)
}

resource "aws_iam_policy" "secretsmanager_access_policy" {
  name        = "${var.prefix}-secretsmanager-access-policy"
  description = "Policy to allow Secrets Manager access for capability access role"
  policy = templatefile("${path.module}/iam/policies/secretsmanager-access.json", {
    secretsmanager_arns = local.secretsmanager_arns
    kms_keys_arns       = local.kms_keys_arns
    aws_region          = var.aws_region
  })
}

locals {
  ssm_parameters = formatlist("arn:aws:ssm:${var.aws_region}:${var.account_id}:parameter%s", var.ssm_parameters)
}

resource "aws_iam_policy" "ssm_access_policy" {
  name        = "${var.prefix}-ssm-access-policy"
  description = "Policy to allow SSM Parameter Store access for capability access role"
  policy = templatefile("${path.module}/iam/policies/ssm-access.json", {
    ssm_parameters = local.ssm_parameters
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.prefix}-s3-access-policy"
  description = "Policy to allow S3 access for capability access role"
  policy = templatefile("${path.module}/iam/policies/s3-access.json", {
    s3_bucket_name = var.s3_bucket_name
  })
}

resource "aws_iam_role_policy_attachment" "rds_connect" {
  role       = data.aws_iam_role.capability_access_role.name
  policy_arn = aws_iam_policy.rds_connect_policy.arn
}

resource "aws_iam_role_policy_attachment" "rds_discovery" {
  role       = data.aws_iam_role.capability_access_role.name
  policy_arn = aws_iam_policy.rds_discovery_policy.arn
}

resource "aws_iam_role_policy_attachment" "secretsmanager_access" {
  role       = data.aws_iam_role.capability_access_role.name
  policy_arn = aws_iam_policy.secretsmanager_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_access" {
  role       = data.aws_iam_role.capability_access_role.name
  policy_arn = aws_iam_policy.ssm_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = data.aws_iam_role.capability_access_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

locals {
  service_account_for_service_1 = "capability-access-service-1"
}

resource "aws_iam_role" "my_role_1" {
  name               = "my-role-for-service-1"
  assume_role_policy = replace(data.aws_iam_role.capability_access_role.assume_role_policy, "capability-access", local.service_account_for_service_1)
}
