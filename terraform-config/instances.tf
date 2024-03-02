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
        mv sonarqube-10.2.0.77647 sonarqube
        sudo useradd sonar
        sudo groupadd sonar
        sudo chown -R sonar:sonar sonarqube
        echo "RUN_AS_USER=sonar" >> /usr/local/sonarqube/bin/linux-x86-64/sonar.sh
        cat >> /etc/systemd/system/sonar.service <<EOF1
[Unit] 
Description=SonarQube service 
After=syslog.target network.target 
[Service] 
Type=forking 
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start 
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop 
User=sonar 
Group=sonar 
Restart=always 
[Install] 
WantedBy=multi-user.target
EOF1
        sudo systemctl daemon-reload
        sudo systemctl enable --now sonar
        EOF
}
