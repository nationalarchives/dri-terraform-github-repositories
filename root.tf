module "configuration" {
  source  = "./da-terraform-configurations"
  project = "dr2"
}

module "github_preservica_client_repository" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-preservica-client"
  secrets = {
    WORKFLOW_TOKEN    = data.aws_ssm_parameter.github_workflow_token.value
    SLACK_WEBHOOK     = data.aws_ssm_parameter.github_slack_webhook.value
    SONATYPE_USERNAME = data.aws_ssm_parameter.github_sonatype_username.value
    SONATYPE_PASSWORD = data.aws_ssm_parameter.github_sonatype_password.value
    GPG_PRIVATE_KEY   = data.aws_ssm_parameter.github_gpg_key.value
    GPG_PASSPHRASE    = data.aws_ssm_parameter.github_gpg_passphrase.value
  }
}


module "dr2_github_actions_scala_steward" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-github-actions"
  secrets = {
    WORKFLOW_TOKEN  = data.aws_ssm_parameter.github_workflow_token.value
    GPG_KEY_ID      = data.aws_ssm_parameter.github_gpg_key_id.value
    GPG_PRIVATE_KEY = data.aws_ssm_parameter.github_gpg_key.value
    GPG_PASSPHRASE  = data.aws_ssm_parameter.github_gpg_passphrase.value
  }
}

module "custodial_copy" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-custodial-copy"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
    GPG_PRIVATE_KEY    = data.aws_ssm_parameter.github_gpg_key.value
    GPG_PASSPHRASE     = data.aws_ssm_parameter.github_gpg_passphrase.value
  }
}

locals {
  account_secrets = {
    for environment, _ in module.configuration.account_numbers : environment => {
      "DR2_${upper(environment)}_ACCOUNT_NUMBER"        = module.configuration.account_numbers[environment]
      "DR2_${upper(environment)}_TERRAFORM_ROLE"        = module.configuration.terraform_config[environment]["terraform_account_role"]
      "DR2_${upper(environment)}_CUSTODIAN_ROLE"        = module.configuration.terraform_config[environment]["custodian_role"]
      "DR2_${upper(environment)}_STATE_BUCKET"          = module.configuration.terraform_config[environment]["state_bucket"]
      "DR2_${upper(environment)}_DYNAMO_TABLE"          = module.configuration.terraform_config[environment]["dynamo_table"]
      "DR2_${upper(environment)}_TERRAFORM_EXTERNAL_ID" = module.configuration.terraform_config[environment]["terraform_external_id"]
    }
  }
}

  module "terraform_environments_repository" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-terraform-environments"
  secrets = merge(local.account_secrets["intg"], local.account_secrets["staging"], local.account_secrets["prod"], local.account_secrets["mgmt"], {
    DR2_MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    DR2_SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    DR2_WORKFLOW_PAT       = data.aws_ssm_parameter.github_workflow_token.value
  })
}

module "terraform_environments_repository_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-terraform-environments"
  team_slug             = "digital-records-repository"
  integration_team_slug = ["digital-records-repository"]
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}

module "github_tna_custodian_repository" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/tna-custodian"
  secrets = merge(local.account_secrets["intg"], local.account_secrets["staging"], local.account_secrets["prod"], local.account_secrets["mgmt"], {
    DR2_MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    DR2_SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    DR2_WORKFLOW_PAT       = data.aws_ssm_parameter.github_workflow_token.value
    DR2_EMAIL_ADDRESS      = module.configuration.terraform_config["notification_email"]
  })
}

module "tna_custodian_repository_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = "dr2-${each.key}"
  repository_name       = "nationalarchives/tna-custodian"
  team_slug             = "digital-records-repository"
  integration_team_slug = ["digital-records-repository"]
}

module "github_tna_aws_accounts_repository" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/tdr-aws-accounts"
  secrets = merge(local.account_secrets["intg"], local.account_secrets["staging"], local.account_secrets["prod"], local.account_secrets["mgmt"], {
    DR2_MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    DR2_SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    DR2_WORKFLOW_PAT       = data.aws_ssm_parameter.github_workflow_token.value
    DR2_EMAIL_ADDRESS      = module.configuration.terraform_config["notification_email"]
  })
}

module "tna_aws_accounts_repository_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = "dr2-${each.key}"
  repository_name       = "nationalarchives/tdr-aws-accounts"
  team_slug             = "digital-records-repository"
  integration_team_slug = ["digital-records-repository"]
}

module "court_document_package_anonymiser" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-court-document-package-anonymiser"
  secrets = {
    SLACK_WEBHOOK             = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN            = data.aws_ssm_parameter.github_workflow_token.value
    MANAGEMENT_ACCOUNT_NUMBER = data.aws_caller_identity.current.account_id
  }
}

module "court_document_package_anonymiser_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-court-document-package-anonymiser"
  team_slug             = "digital-records-repository"
  integration_team_slug = []
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}

module "dr2_ingest" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-ingest"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
  }
}

module "dr2_ingest_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-ingest"
  team_slug             = "digital-records-repository"
  integration_team_slug = []
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}

module "dr2_runbooks" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-runbooks"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
  }
}

module "dr2_runbooks_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-runbooks"
  team_slug             = "digital-records-repository"
  integration_team_slug = []
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}
