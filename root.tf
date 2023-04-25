module "github_environments_repository" {
  source          = "./repositories"
  repository_name = "dp-preservica-client"
  language        = "Scala"
  checks          = ["test:test"]
  team_name       = "digital-records-infrastructure"
  team_permission = "admin"
  secrets = {
    WORKFLOW_TOKEN    = data.aws_ssm_parameter.github_workflow_token.value
    SLACK_WEBHOOK     = data.aws_ssm_parameter.github_slack_webhook.value
    SONATYPE_USERNAME = data.aws_ssm_parameter.github_sonatype_username.value
    SONATYPE_PASSWORD = data.aws_ssm_parameter.github_sonatype_password.value
    GPG_PRIVATE_KEY   = data.aws_ssm_parameter.github_gpg_key.value
    GPG_PASSWORD      = data.aws_ssm_parameter.github_gpg_passphrase.value
  }
}
