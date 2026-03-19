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
