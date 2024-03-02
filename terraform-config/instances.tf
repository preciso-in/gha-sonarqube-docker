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

  metadata_startup_script = <<-EOF
        #!/bin/bash
        apt-get update -y
        sudo apt install openjdk-17-jre unzip -y
        cd /usr/local
        wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.2.0.77647.zip
        unzip sonarqube-10.2.0.77647.zip
        rm sonarqube-10.2.0.77647.zip
        chown neellearngcp -R sonarqube-10.2.0.77647/
        EOF
}
