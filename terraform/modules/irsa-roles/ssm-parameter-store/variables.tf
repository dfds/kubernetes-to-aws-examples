variable "aws_region" {
  type    = string
  description = "The AWS region to deploy resources in."
  default = "eu-west-1"
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

variable "ssm_parameters" {
  type = list(string)
  description = "A list of SSM parameter paths to be accessed. Example: ['/myapp/db/password', '/myapp/db/username']"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to resources."
}
