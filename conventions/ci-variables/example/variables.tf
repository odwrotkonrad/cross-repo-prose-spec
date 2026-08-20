##[>] 🤖🤖
resource "gitlab_group_variable" "artifact_registry" {
  group     = var.token_group_path
  key       = "GRP_KO_VAR_ARTIFACT_REGISTRY"
  value     = var.artifact_registry
  masked    = false
  protected = false
}

resource "gitlab_group_variable" "ci_images_ref" {
  group     = var.token_group_path
  key       = "GRP_KO_VAR_CI_IMAGES_REF"
  value     = var.ci_images_ref
  masked    = false
  protected = false
}

resource "gitlab_group_variable" "che_packages_ref" {
  group     = var.token_group_path
  key       = "GRP_KO_VAR_CHE_PACKAGES_REF"
  value     = var.che_packages_ref
  masked    = false
  protected = false
}

resource "gitlab_group_variable" "gitlab_token" {
  group     = var.token_group_path
  key       = "GRP_KO_VAR_GITLAB_TOKEN"
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
