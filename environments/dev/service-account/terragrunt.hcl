include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/service-account"
}

inputs = {
  account_id   = "github-actions-sa"
  display_name = "GitHub Actions Service Account"
}