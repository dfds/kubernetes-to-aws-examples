locals {
  secretsmanager_arns = formatlist("arn:aws:secretsmanager:${var.aws_region}:${var.account_id}:secret:%s", var.secretsmanager_secret_names)
  kms_keys_arns       = formatlist("arn:aws:kms:${var.aws_region}:${var.account_id}:key/%s", var.kms_keys)
}

resource "aws_iam_policy" "secretsmanager_access_policy" {
  name        = "${var.prefix}-secretsmanager-access-policy-for-rds"
  description = "Policy to allow Secrets Manager access for capability access role"
  policy = templatefile("${path.module}/policies/secretsmanager-access.json", {
    secretsmanager_arns = local.secretsmanager_arns
    kms_keys_arns       = local.kms_keys_arns
    aws_region          = var.aws_region
  })
}

resource "aws_iam_policy" "rds_connect_policy" {
  name        = "${var.prefix}-rds-connect-policy"
  description = "Policy to allow RDS connectivity for capability access role"
  policy = templatefile("${path.module}/policies/rds-connect.json", {
    aws_region      = var.aws_region,
    account_id      = var.account_id
    rds_resource_id = var.rds_resource_id
  })
}

resource "aws_iam_policy" "rds_discovery_policy" {
  name        = "${var.prefix}-rds-discovery-policy"
  description = "Policy to allow RDS discovery for capability access role"
  policy = templatefile("${path.module}/policies/rds-discovery.json", {
    aws_region = var.aws_region,
    account_id = var.account_id
  })
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = replace(var.assume_role_policy_default, "capability-access", var.service_account_name)
}

resource "aws_iam_role_policy_attachment" "rds_connect" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.rds_connect_policy.arn
}

resource "aws_iam_role_policy_attachment" "rds_discovery" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.rds_discovery_policy.arn
}

resource "aws_iam_role_policy_attachment" "secretsmanager_access" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.secretsmanager_access_policy.arn
}
