# kubernetes-to-aws-examples

Examples on how to create IAM Policies and use it with our CapabilityAccessFromKubernetes IAM Role.

## Terraform examples

### Covers the following use cases

- Discovery of RDS databases. Either directly or through RDS Proxies.
- Connect to RDS databases.
- Read from AWS Secrets Manager.
- Read from AWS SSM Parameter Store.
- Read and write to AWS S3 bucket.

All policies aim to provide least privileged access.

### Tested with

```bash
tofu version
OpenTofu v1.11.1
on darwin_arm64
+ provider registry.opentofu.org/hashicorp/aws v6.28.0
```

## Kubernetes example

In the file k8s/serviceaccount.yaml you need to change `<account-id>` to your actual numeric AWS account-id.
In both deployment.yaml and serviceaccount.yaml you need to change `<capability-namespace>` to your actual namespace

**Then apply it to Kubernetes:**

```bash
kubectl apply -k k8s/
```

**Start as shell inside the pod:**

```bash
kubectl -n <capability-namespace> get pods
kubectl -n <capability-namespace> exec --stdin --tty <pod-name> -- /bin/bash
```

**Test that you are logged on to AWS through the serviceaccount used by the pod:**

```bash
aws sts get-caller-identity
```
