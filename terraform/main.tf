# This role already exist in your capability.
# Don't use it. By using a data source, we can copy its trust relationship and
# use it to create new roles for other service accounts when needed.
data "aws_iam_role" "capability_access_role" {
  name = "CapabilityAccessFromKubernetes"
}

# Your input to local variables
locals {
  aws_region = "eu-west-1"
  prefix     = "k8s2aws"

  tags = {
    "dfds.env"         = "dev"
    "dfds.cost.centre" = "ti-platform"
  }
}

# Calculated local variables
locals {
  assume_role_policy_default = data.aws_iam_role.capability_access_role.assume_role_policy

  # Kubernetes ServiceAccount names that will assume the various roles
  rds_sa_name            = "${local.prefix}-rds-sa"
  s3_sa_name             = "${local.prefix}-s3-sa"
  secretsmanager_sa_name = "${local.prefix}-secretsmanager-sa"
  ssm_sa_name            = "${local.prefix}-ssm-sa"

  # Role names
  rds_role_name = "${local.prefix}-rds-access-role"
  s3_role_name  = "${local.prefix}-s3-access-role"
  sm_role_name  = "${local.prefix}-secretsmanager-access-role"
  ssm_role_name = "${local.prefix}-ssm-access-role"
}

################################################################################
### Create IRSA role for RDS access                                          ###
### from your capability namespace in K8S to your AWS account                ###
################################################################################

module "irsa_roles_rds" {
  source                     = "./modules/irsa-roles/rds"
  aws_region                 = local.aws_region
  assume_role_policy_default = local.assume_role_policy_default
  service_account_name       = local.rds_sa_name
  prefix                     = local.prefix
  account_id                 = var.account_id
  rds_resource_id            = var.rds_resource_id
  role_name                  = local.rds_role_name
  tags                       = local.tags
}

################################################################################
### Create IRSA role for S3 access                                           ###
### from your capability namespace in K8S to your AWS account                ###
################################################################################

module "irsa_role_s3" {
  source                     = "./modules/irsa-roles/s3"
  aws_region                 = local.aws_region
  assume_role_policy_default = local.assume_role_policy_default
  service_account_name       = local.s3_sa_name
  prefix                     = local.prefix
  s3_bucket_name             = var.s3_bucket_name
  role_name                  = local.s3_role_name
  tags                       = local.tags

}

################################################################################
### Create IRSA role for SSM Parameter Store access                          ###
### from your capability namespace in K8S to your AWS account                ###
################################################################################

module "irsa_role_ssm_parameter_store" {
  source                     = "./modules/irsa-roles/ssm-parameter-store"
  aws_region                 = local.aws_region
  assume_role_policy_default = local.assume_role_policy_default
  service_account_name       = local.ssm_sa_name
  prefix                     = local.prefix
  account_id                 = var.account_id
  ssm_parameters             = ["/test/secret1", "/test/secret2"]
  role_name                  = local.ssm_role_name
  tags                       = local.tags
}

################################################################################
### Create IRSA role for Secrets Manager access                              ###
### from your capability namespace in K8S to your AWS account                ###
################################################################################

module "irsa_role_secrets_manager" {
  source                      = "./modules/irsa-roles/secrets-manager"
  aws_region                  = local.aws_region
  assume_role_policy_default  = local.assume_role_policy_default
  service_account_name        = local.secretsmanager_sa_name
  prefix                      = local.prefix
  account_id                  = var.account_id
  secretsmanager_secret_names = var.secretsmanager_secret_names
  kms_keys                    = var.kms_keys
  role_name                   = local.sm_role_name
  tags                        = local.tags
}
