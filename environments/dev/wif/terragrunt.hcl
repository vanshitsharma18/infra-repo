include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/wif"
}

inputs = {
  pool_id     = "github-pool"
  provider_id = "github-provider"

  github_repositories = [
    "vanshitsharma18/infra-repo",
    "vanshitsharma18/frontend-repo",
    "vanshitsharma18/backend-repo"
  ]

  service_account_id = "projects/devops-lab-498208/serviceAccounts/github-actions-sa@devops-lab-498208.iam.gserviceaccount.com"
}