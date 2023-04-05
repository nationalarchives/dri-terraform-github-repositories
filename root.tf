module "github_environments_repository" {
  source          = "./repositories"
  repository_name = "dri-terraform-github-environments"
  language        = "Scala"
  checks          = ["terraform-check:0"]
}

module "repository_role" {
  source = "git::https://github.com/nationalarchives/tdr-terraform-modules.git//iam_role"
  name   = "DRITerraformRepositoriesRoleMgmt"
  common_tags = {
    Name = "DRITerraformRepositoriesRoleMgmt"
  }
  assume_role_policy = templatefile("./templates/role/github_assume_role.json.tpl", { account_id = data.aws_caller_identity.current.account_id })
  policy_attachments = {
    access_state_s3_bucket = module.repository_policy.policy_arn
  }
}

module "repository_policy" {
  source        = "git::https://github.com/nationalarchives/tdr-terraform-modules.git//iam_policy"
  name          = "DRITerraformRepositoriesPolicyMgmt"
  policy_string = templatefile("./templates/policy/terraform_policy.json.tpl", { bucket_name = local.bucket_name, account_id = data.aws_caller_identity.current.account_id })
}
