# DR2 Terraform GitHub repositories

This repository is used to add secrets to existing repositories for dp (dr2) repositories.
This allows us to add secrets directly from Parameter Store / Secrets Manager

## Running Terraform Project Locally

1. Clone DR2 GitHub Repositories project to local machine: https://github.com/nationalarchives/dr2-terraform-github-repositories and navigate to the directory
2. Initialize Terraform (if not done so previously):

   ```
   [location of project] $ terraform init
   ```

3. To ensure the modules are up-to-date, run
   ```
   [location of project] $ terraform get -update
   ```

4. (After making your changes) Run Terraform to view changes that will be made to the DR2 environment AWS resources

   ```
   [location of project] $ terraform plan
   ```
5. Run `terraform fmt --recursive` to properly format your Terraform changes before pushing to a branch.


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

On merge to main, GitHub Actions will run Terraform to create the new repository.
