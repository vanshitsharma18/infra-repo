output "email" {
  description = "Service Account Email"
  value       = google_service_account.this.email
}

output "name" {
  description = "Service Account Name"
  value       = google_service_account.this.name
}
