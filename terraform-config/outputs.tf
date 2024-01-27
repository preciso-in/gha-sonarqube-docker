output "jenkins-url" {
  value     = "http://${google_compute_instance_from_template.jenkins.network_interface[0].access_config[0].nat_ip}:8080"
  sensitive = false
}

output "jenkins-webhook-url" {
  value     = "http://${google_compute_instance_from_template.jenkins.network_interface[0].access_config[0].nat_ip}:8080/github-webhook/"
  sensitive = false
}


output "sonarqube-url" {
  value     = "http://${google_compute_instance_from_template.sonarqube.network_interface[0].access_config[0].nat_ip}:9000"
  sensitive = false
}

output "docker-url" {
  value     = "http://${google_compute_instance_from_template.docker.network_interface[0].access_config[0].nat_ip}:8085"
  sensitive = false
}

output "jenkins-server-name" {
  value     = google_compute_instance_from_template.jenkins.name
  sensitive = false
}

output "sonarquber-server-name" {
  value     = google_compute_instance_from_template.sonarqube.name
  sensitive = false
}

output "docker-server-name" {
  value     = google_compute_instance_from_template.docker.name
  sensitive = false
}

output "docker-server-ip" {
  value     = google_compute_instance_from_template.docker.network_interface[0].access_config[0].nat_ip
  sensitive = false
}