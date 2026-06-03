output "load_balancer_ip" {
  value = google_compute_global_address.lb_ip.address
}

output "frontend_backend_service" {
  value = google_compute_backend_service.frontend_backend.id
}

output "api_backend_service" {
  value = google_compute_backend_service.api_backend.id
}

output "ssl_certificate_name" {
  value = google_compute_managed_ssl_certificate.cert.name
}