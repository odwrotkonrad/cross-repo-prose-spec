##[>] 🤖🤖
resource "gitlab_group_variable" "artifact_registry" {
  group     = var.token_group_path
  key       = "GRP_VAR_ARTIFACT_REGISTRY"
  value     = var.artifact_registry
  masked    = false
  protected = false
}

resource "gitlab_group_variable" "gitlab_token" {
  group     = var.token_group_path
  key       = "GRP_VAR_GITLAB_TOKEN"
  value     = var.gitlab_token
  masked    = true
  protected = true
}

resource "gitlab_project_variable" "github_token" {
  project   = var.project_path
  key       = "REPO_VAR_GITHUB_TOKEN"
  value     = var.github_token
  masked    = true
  protected = true
}
##[<] 🤖🤖
