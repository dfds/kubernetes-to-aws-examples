variable "aws_region" {
  type    = string
  description = "The AWS region to deploy resources in"
  default = "eu-west-1"
}

variable "account_id" {
  type        = string
  description = "The AWS account ID where resources will be deployed"
}

variable "prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = "k8s-to-aws-examples"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to resources"
  default     = {}
}
