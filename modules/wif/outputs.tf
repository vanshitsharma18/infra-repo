output "pool_name" {
  value = google_iam_workload_identity_pool.pool.name
}

output "provider_name" {
  value = google_iam_workload_identity_pool_provider.github.name
}

output "allowed_repositories" {
  value = var.github_repositories
}