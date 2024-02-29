resource "google_compute_instance" "sonar_scanner" {
  name         = "code-scanner"
  zone         = "${var.region}-a"
  machine_type = "custom-1-5120"
  description  = "Sonar Scanner Instance"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  tags = [var.sonarqube_network_tag]

  network_interface {
    network    = var.network_name
    subnetwork = google_compute_subnetwork.subnetwork.id

    # Empty Access Config block associates instance with an ephemeral external IP
    access_config {}
  }
}
