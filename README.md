# kubernetes-to-aws-examples

Examples on how to create IAM Policies and use it with our CapabilityAccessFromKubernetes IAM Role.

## Covers the following use cases

- Discovery of RDS databases. Either directly or through RDS Proxies.
- Connect to RDS databases.
- Read from AWS Secrets Manager.
- Read from AWS SSM Parameter Store.
- Read and write to AWS S3 bucket.

All policies aim to provide least privileged access.

## Tested with

```zsh
tofu version
OpenTofu v1.11.1
on darwin_arm64
+ provider registry.opentofu.org/hashicorp/aws v6.28.0
```
