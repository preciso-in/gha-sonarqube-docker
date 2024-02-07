# Site Deployment on GCP using Github Actions

[![Create Sonarqube Docker Workflow](https://github.com/preciso-in/gha-sonarqube-docker/actions/workflows/main.yml/badge.svg)](https://github.com/preciso-in/gha-sonarqube-docker/actions/workflows/main.yml)

- Will Deploy a simple Website with JS, JQuery and Animations on GCP VM

- Github Actions for CI/CD,

- Super Linter for Static Code Analysis

- Nektos Act for local Development. If local machine is Arm Based SoC like Apple M Machines, you can use GCP Cloud shell to run Act.

---

## Features

- [x] Scripts - using Makefile
- [x] SuperLinter
  - Use locally with docker. Run "make start_super_linter_docker"
  - Part of Github Actions Workflow.
- [x] Use Nektos Act for faster development
- [ ] Gcloud to create GCP resources
- [ ] Terraform to create GCP Resources.
- [ ] Github Variables for Project, Storage Bucket, etc.
- [ ] Trivy CVE Scanning
- [ ] GCP auth using WIF & SA keys
- [ ] Prometheus monitoring.
- [ ] Buildkit cache for faster workflows.
- [ ] Docker images with metadata & tags.
- [ ] Hashicorp Vault.
- [ ] NPM for Website instead of downloaded scripts.

<!-- Borrow structure and ideas from  Jenkins-Sonarqube-Docker-TF -->
