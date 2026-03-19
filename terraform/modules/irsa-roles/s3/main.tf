resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.prefix}-s3-access-policy"
  description = "Policy to allow S3 access for capability access role"
  policy = templatefile("${path.module}/policies/s3-access.json", {
    s3_bucket_name = var.s3_bucket_name
  })
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = replace(var.assume_role_policy_default, "capability-access", var.service_account_name)
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}
