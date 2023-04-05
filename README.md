# DRI Terraform GitHub repositories

This repository is used to create new repositories for the DRI project.
This means we have a record of the repositories we are using and ensures that they are set up correctly.

## Create a new repository
Add a new module in the `root.tf` file

```terraform
module "github_environments_repository" {
  source          = "./repositories"
  repository_name = "dri-terraform-github-environments"
  language        = "Scala"
  checks          = ["test:test.yml"]
  collaborators   = ["a_contractor"]
  dependabot_secrets = {
    "DEPENDABOT_SECRET_NAME" : data.aws_ssm_parameter.dependabot_secret.value
  }
  secrets = {
    "ACTIONS_SECRET_NAME" : data.aws_ssm_parameter.actions_secret.value
  }
}

```
Raise a pull request to merge to the main branch.

On merge to main, GitHub actions will run terraform to create the new repository.
