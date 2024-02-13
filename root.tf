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

module "github_dynamo_formatters_repository" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-dynamo-formatters"
  secrets = {
    WORKFLOW_TOKEN    = data.aws_ssm_parameter.github_workflow_token.value
    SLACK_WEBHOOK     = data.aws_ssm_parameter.github_slack_webhook.value
    SONATYPE_USERNAME = data.aws_ssm_parameter.github_sonatype_username.value
    SONATYPE_PASSWORD = data.aws_ssm_parameter.github_sonatype_password.value
    GPG_PRIVATE_KEY   = data.aws_ssm_parameter.github_gpg_key.value
    GPG_PASSPHRASE    = data.aws_ssm_parameter.github_gpg_passphrase.value
  }
}

module "github_sbt_assembly_log4j_plugin_repository" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/sbt-assembly-log4j"
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
  repository_name = "nationalarchives/dr2-preservica-config"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
  }
}

module "ingest_parsed_court_documents_event_handler_lambda" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-ingest-parsed-court-document-event-handler"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
  }
}

module "ingest_parsed_court_documents_event_handler_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-ingest-parsed-court-document-event-handler"
  team_slug             = "digital-records-repository"
  integration_team_slug = []
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}

module "e2e_tests" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-e2e-tests"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
  }
}

module "e2e_tests_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-e2e-tests"
  team_slug             = "digital-records-repository"
  integration_team_slug = []
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}

module "ingest_asset_opex_creator_lambda" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-ingest-asset-opex-creator"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
  }
}

module "ingest_asset_opex_creator_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-ingest-asset-opex-creator"
  team_slug             = "digital-records-repository"
  integration_team_slug = []
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}

module "ingest_folder_opex_creator_lambda" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-ingest-folder-opex-creator"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
  }
}

module "ingest_folder_opex_creator_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-ingest-folder-opex-creator"
  team_slug             = "digital-records-repository"
  integration_team_slug = []
  secrets = {
    ACCOUNT_NUMBER = each.value
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

module "ingest_mapper_lambda" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-ingest-mapper"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
  }
}

module "ingest_mapper_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-ingest-mapper"
  team_slug             = "digital-records-repository"
  integration_team_slug = []
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}

module "ingest_upsert_archive_lambda" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-ingest-upsert-archive-folders"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
  }
}

module "ingest_upsert_archive_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-ingest-upsert-archive-folders"
  team_slug             = "digital-records-repository"
  integration_team_slug = []
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}

module "entity_event_generation_lambda" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-entity-event-generator"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
  }
}

module "entity_event_generation_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-entity-event-generator"
  team_slug             = "digital-records-repository"
  integration_team_slug = ["digital-records-repository"]
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}

locals {
  account_secrets = {
    for environment, _ in module.configuration.account_numbers : environment => {
      "DR2_${upper(environment)}_ACCOUNT_NUMBER"        = module.configuration.account_numbers[environment]
      "DR2_${upper(environment)}_TERRAFORM_ROLE"        = module.configuration.terraform_config[environment]["terraform_role"]
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

module "ip_locker_lambda" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-ip-lock-checker"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
  }
}

module "ip_locker_lambda_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-ip-lock-checker"
  team_slug             = "digital-records-repository"
  integration_team_slug = []
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
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

module "ingest_start_workflow_lambda" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-start-workflow"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
  }
}

module "ingest_start_workflow_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-start-workflow"
  team_slug             = "digital-records-repository"
  integration_team_slug = []
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}

module "ingest_parent_folder_opex_creator_lambda" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-ingest-parent-folder-opex-creator"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
  }
}

module "ingest_parent_folder_opex_creator_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-ingest-parent-folder-opex-creator"
  team_slug             = "digital-records-repository"
  integration_team_slug = []
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}

module "ingest_s3_copy_lambda" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-s3-copy"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
  }
}

module "ingest_s3_copy_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-s3-copy"
  team_slug             = "digital-records-repository"
  integration_team_slug = []
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}

module "ingest_workflow_monitor_lambda" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-ingest-workflow-monitor"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
  }
}

module "ingest_workflow_monitor_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-ingest-workflow-monitor"
  team_slug             = "digital-records-repository"
  integration_team_slug = []
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}

module "ingest_asset_reconciler_lambda" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repository_secrets"
  repository_name = "nationalarchives/dr2-ingest-asset-reconciler"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
    WORKFLOW_TOKEN     = data.aws_ssm_parameter.github_workflow_token.value
  }
}

module "ingest_asset_reconciler_environments" {
  for_each              = module.configuration.account_numbers
  source                = "git::https://github.com/nationalarchives/da-terraform-modules//github_environment_secrets"
  environment           = each.key
  repository_name       = "nationalarchives/dr2-ingest-asset-reconciler"
  team_slug             = "digital-records-repository"
  integration_team_slug = []
  secrets = {
    ACCOUNT_NUMBER = each.value
  }
}
