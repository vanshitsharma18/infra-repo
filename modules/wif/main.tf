resource "google_iam_workload_identity_pool" "pool" {
  workload_identity_pool_id = var.pool_id
  display_name              = var.pool_id
  description               = "GitHub Actions Workload Identity Pool"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id

  display_name = "GitHub Provider"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_condition = join(
    " || ",
    [
      for repo in var.github_repositories :
      "attribute.repository == \"${repo}\""
    ]
  )
}

resource "google_service_account_iam_member" "github" {
  for_each = toset(var.github_repositories)

  service_account_id = var.service_account_email

  role = "roles/iam.workloadIdentityUser"

  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.pool.name}/attribute.repository/${each.value}"
}