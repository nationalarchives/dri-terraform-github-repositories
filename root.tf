module "github_preservica_client_repository" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dp-preservica-client"
  secrets = {
    WORKFLOW_TOKEN    = data.aws_ssm_parameter.github_workflow_token.value
    SLACK_WEBHOOK     = data.aws_ssm_parameter.github_slack_webhook.value
    SONATYPE_USERNAME = data.aws_ssm_parameter.github_sonatype_username.value
    SONATYPE_PASSWORD = data.aws_ssm_parameter.github_sonatype_password.value
    GPG_PRIVATE_KEY   = data.aws_ssm_parameter.github_gpg_key.value
    GPG_PASSPHRASE    = data.aws_ssm_parameter.github_gpg_passphrase.value
  }
}

module "github_preservica_config_repository" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dp-preservica-config"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
  }
}

module "closure_expiration_event_lambda" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dp-closure-expiration-event-generation"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
  }
}

locals {
  environment_map = {
    intg    = data.aws_ssm_parameter.intg_account_number.value
    staging = data.aws_ssm_parameter.staging_account_number.value
    prod    = data.aws_ssm_parameter.prod_account_number.value
  }
}

module "terraform_environments_repository" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dp-terraform-environments"
  secrets = {
    MANAGEMENT_ACCOUNT     = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK          = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN         = data.aws_ssm_parameter.github_workflow_token.value
    INTG_ACCOUNT_NUMBER    = data.aws_ssm_parameter.intg_account_number.value
    STAGING_ACCOUNT_NUMBER = data.aws_ssm_parameter.staging_account_number.value
    PROD_ACCOUNT_NUMBER    = data.aws_ssm_parameter.prod_account_number.value
  }
}

module "terraform_environments_repository_environments" {
  for_each              = local.environment_map
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dp-terraform-environments"
  team_slug             = "digital-records-repository"
  integration_team_slug = ["digital-records-repository"]
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}
