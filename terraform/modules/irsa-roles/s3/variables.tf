variable "aws_region" {
  type    = string
  description = "The AWS region to deploy resources in."
}

variable "assume_role_policy_default" {
  type        = string
  description = "The default assume role policy to use for the IAM role."
}

variable "service_account_name" {
  type        = string
  description = "Kubernetes ServiceAccount name that will assume the role."
}

variable "role_name" {
  type        = string
  description = "The name of the IAM role to create."
}

variable "prefix" {
  type        = string
  description = "Prefix for resource names."
}

variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket to be used. Example: 'myapp-bucket'"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to resources."
}
