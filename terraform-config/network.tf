resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = var.subnet_name
  ip_cidr_range = "10.0.20.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "allow_ssh" {
  name      = "allow-ssh"
  direction = "INGRESS"
  priority  = 65534
  network   = google_compute_network.vpc_network.id

  # 35.235.240.0/20 is the IP range of GCP cloud shell
  source_ranges = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_sonarqube" {
  name          = "allow-sonarqube"
  direction     = "INGRESS"
  priority      = 1000
  network       = google_compute_network.vpc_network.id
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["9000"]
  }
  target_tags = [var.sonarqube_network_tag]
}
