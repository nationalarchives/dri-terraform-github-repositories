# DR2 Terraform GitHub repositories

This repository is used to add secrets to existing repositories for dp (dr2) repositories.
This allows us to add secrets directly from parameter store / secrets manager

## Create a new repository
Add a new module in the `root.tf` file

```terraform
module "github_preservica_client_repository" {
  source          = "git::https://github.com/nationalarchives/da-terraform-modules//github_repositories"
  repository_name = "nationalarchives/dp-example-repo"
  secrets = {
    "ACTIONS_SECRET_NAME" : data.aws_ssm_parameter.actions_secret.value
  }
}
```
Raise a pull request to merge to the main branch.

On merge to main, GitHub actions will run terraform to create the new repository.
