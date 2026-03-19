locals {
  ssm_parameters = formatlist("arn:aws:ssm:${var.aws_region}:${var.account_id}:parameter%s", var.ssm_parameters)
}

resource "aws_iam_policy" "ssm_access_policy" {
  name        = "${var.prefix}-ssm-access-policy"
  description = "Policy to allow SSM Parameter Store access for capability access role"
  policy = templatefile("${path.module}/policies/ssm-access.json", {
    ssm_parameters = local.ssm_parameters
  })
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = replace(var.assume_role_policy_default, "capability-access", var.service_account_name)
}

resource "aws_iam_role_policy_attachment" "ssm_access" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.ssm_access_policy.arn
}
