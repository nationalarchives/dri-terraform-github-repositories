resource "github_repository" "repository" {
  name                   = var.repository_name
  description            = var.description
  visibility             = var.visibility
  delete_branch_on_merge = true
  gitignore_template     = var.language
  security_and_analysis {
    secret_scanning_push_protection {
      status = "enabled"
    }
    secret_scanning {
      status = "enabled"
    }
  }
}

resource "github_branch_default" "default" {
  repository = github_repository.repository.name
  branch     = var.main_branch

}

resource "github_branch_protection_v3" "branch_protection" {
  branch                 = var.main_branch
  repository             = github_repository.repository.name
  enforce_admins         = true
  require_signed_commits = true
  required_status_checks {
    strict = true
    checks = var.checks
  }
  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 1
  }
}

resource "github_actions_secret" "repository_secret" {
  for_each        = var.secrets
  repository      = github_repository.repository.name
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_dependabot_secret" "repository_secret" {
  for_each        = var.dependabot_secrets
  repository      = github_repository.repository.name
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_repository_collaborator" "collaborators" {
  for_each   = var.collaborators
  repository = github_repository.repository.name
  username   = each.value
}
