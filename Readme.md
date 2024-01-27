# Site Deployment on GCP using Jenkins CI/CD

### Terraform IaC configuration to deploy GCP resources

### Jenkins for CI/CD,

### Sonarqube for Quality Scanning before Docker deploys website.

---

#### Setup, Deployment & Cleanup

Instructions folder contain instructions to Setup, Deploy and Cleanup Resources used in this project.

All 3 activities are executed using bash scripts that call Terraform CLI with required inputs.

---

### Best Practices Used:

- IAC (Terraform) used to create GCP resources.
- GCP VM instances are preconfigured with Jenkins, Sonarqube and Docker using Startup scripts hosted in GCP Cloud Storage
- Individual scripts to Create, Destroy and Update limit user interaction to supplying Project_ID and bucket_id and region.
- Git Commits are required to map to a story-id.
- GCP VMs are created on pre-emptible spot instances to keep GCP billing charges to a minimum.

---

### Benefits of using Terraform over gcloud CLI in bash scripts

<!-- TODO: Write your own experience here. How much time this saved and how much state management is easier. Use Bard & ChatGPT to structure this. -->



TBA

---

### Charges applicable on GCP for this deployment

VMs created on GCP that host Jenkins, Sonarqube and Docker runtime will be charged.

These VMs are Spot Preemptible instances. However, they will incur charges.

Rest of the resources created like startup scripts stored on GCP are negligible in cost. Hence, you can keep them.

However, project created will be counted against your Projects quota and billing quota.
Hence, it is advisable to delete these when no longer required using instructions listed in ./instructions/cleanup-instructions.md
