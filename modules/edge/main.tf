# ============================================================================
# HTTPS LOAD BALANCER FOR CLOUD RUN
# Frontend -> /
# Backend  -> /api/*
# ============================================================================

# ============================================================================
# GLOBAL STATIC IP
# ============================================================================

resource "google_compute_global_address" "lb_ip" {
  name         = "incident-lb-ip"
  address_type = "EXTERNAL"
}

# ============================================================================
# SERVERLESS NEG - FRONTEND
# ============================================================================

resource "google_compute_region_network_endpoint_group" "frontend_neg" {
  name                  = "${var.frontend_service_name}-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = var.frontend_service_name
  }
}

# ============================================================================
# SERVERLESS NEG - BACKEND
# ============================================================================

resource "google_compute_region_network_endpoint_group" "backend_neg" {
  name                  = "${var.backend_service_name}-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = var.backend_service_name
  }
}

# ============================================================================
# FRONTEND BACKEND SERVICE
# ============================================================================

resource "google_compute_backend_service" "frontend_backend" {
  name                  = "${var.frontend_service_name}-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  timeout_sec           = 30
  enable_cdn            = false
  session_affinity      = "NONE"

  backend {
    group = google_compute_region_network_endpoint_group.frontend_neg.id
  }

  log_config {
    enable = true
  }
}

# ============================================================================
# API BACKEND SERVICE
# ============================================================================

resource "google_compute_backend_service" "api_backend" {
  name                  = "${var.backend_service_name}-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  timeout_sec           = 30
  enable_cdn            = false
  session_affinity      = "NONE"

  backend {
    group = google_compute_region_network_endpoint_group.backend_neg.id
  }

  log_config {
    enable = true
  }
}

# ============================================================================
# URL MAP
# ============================================================================

resource "google_compute_url_map" "main" {
  name = "incident-url-map"

  default_service = google_compute_backend_service.frontend_backend.id

  host_rule {
    hosts        = [var.domain_name]
    path_matcher = "incident-routes"
  }

  path_matcher {
    name            = "incident-routes"
    default_service = google_compute_backend_service.frontend_backend.id

    path_rule {
      paths = [
        "/api",
        "/api/*"
      ]

      service = google_compute_backend_service.api_backend.id
    }
  }
}

# ============================================================================
# GOOGLE MANAGED SSL
# ============================================================================

resource "google_compute_managed_ssl_certificate" "cert" {
  name = "incident-ssl-cert"

  managed {
    domains = [var.domain_name]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ============================================================================
# SSL POLICY
# ============================================================================

resource "google_compute_ssl_policy" "policy" {
  name            = "incident-ssl-policy"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}

# ============================================================================
# HTTPS PROXY
# ============================================================================

resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "incident-https-proxy"
  url_map          = google_compute_url_map.main.id
  ssl_certificates = [google_compute_managed_ssl_certificate.cert.id]
  ssl_policy       = google_compute_ssl_policy.policy.id
}

# ============================================================================
# HTTPS FORWARDING RULE
# ============================================================================

resource "google_compute_global_forwarding_rule" "https" {
  name                  = "incident-https-forwarding-rule"
  ip_address            = google_compute_global_address.lb_ip.address
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.https_proxy.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

# ============================================================================
# HTTP -> HTTPS REDIRECT
# ============================================================================

resource "google_compute_url_map" "http_redirect" {
  name = "incident-http-redirect"

  default_url_redirect {
    https_redirect         = true
    strip_query            = false
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
  }
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "incident-http-proxy"
  url_map = google_compute_url_map.http_redirect.id
}

resource "google_compute_global_forwarding_rule" "http" {
  name                  = "incident-http-forwarding-rule"
  ip_address            = google_compute_global_address.lb_ip.address
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http_proxy.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
}