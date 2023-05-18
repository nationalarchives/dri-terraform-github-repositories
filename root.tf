module "github_preservica_client_repository" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repositories"
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
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repositories"
  repository_name = "nationalarchives/dp-preservica-config"
  secrets = {
    MANAGEMENT_ACCOUNT = data.aws_caller_identity.current.account_id
    SLACK_WEBHOOK      = data.aws_ssm_parameter.github_slack_webhook.value
  }
}
