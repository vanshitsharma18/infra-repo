output "repository_name" {
  value = google_artifact_registry_repository.repo.repository_id
}

output "repository_url" {
  value = "${var.region}-docker.pkg.dev"
}