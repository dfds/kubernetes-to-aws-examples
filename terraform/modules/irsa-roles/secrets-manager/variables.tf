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

variable "account_id" {
  type        = string
  description = "The AWS account ID where resources will be deployed."
}

variable "prefix" {
  type        = string
  description = "Prefix for resource names."
}

variable "kms_keys" {
  type = list(string)
  description = "A list of KMS key IDs to be accessed. Example: ['key-id1', 'key-id2']"
}

variable "secretsmanager_secret_names" {
  type = list(string)
  description = "A list of Secrets Manager secret names to be accessed. Example: ['secret-name1', 'secret-name2']"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to resources."
}
