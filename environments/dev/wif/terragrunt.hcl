inputs = {
  pool_id      = "github-pool"
  provider_id  = "github-provider"

  github_repositories = [
    "vanshitsharma18/infra-repo",
    "vanshitsharma18/frontend-repo",
    "vanshitsharma18/backend-repo"
  ]

  service_account_email = "github-actions-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com"
}