# Setting up your environment before running the scripts

---

<details >
<summary>Authenticate into GCP</summary>

> Install Google Cloud CLI

```
https://cloud.google.com/sdk/docs/install#mac
```

> Login to Google Cloud using CLI

```
> gcloud auth login
```

> Enable access for Terraform to GCP

```
> gcloud auth application-default login
```

</details>

---

<details >
<summary>Providing Defaults to the tf-create script</summary>

> Update ./scripts/default-values.sh to provide default values that the script can use.

You can override these values by specifying the following flags with the script

- --project_id
- --bucket_id
- --region

_In case you need to perform more fine tuning of naming the resources created, you should modify ./scripts/modules/config.sh file._

</details>

---

<details >
<summary>Git instructions</summary>

> Ensure Story-Id in Commit Message

```
cd scripts
$ chmod +x enforce-story-id.sh
$ sh enforce-story-id.sh
```

</details>

---

<details>
<summary>Terraform Initialisation</summary>
> Simple Terraform initialisation

```
> terraform init
```

> Terraform initialisation after change in Backend

```
> terraform init --migrate-state
```

> Terraform initialisation specifying new backend

```
> terraform init --backend-config=backend.hcl --migrate-state
```

</details>

---

<details >
<summary>Housekeeping (Updates, cleanup)</summary>

##### Miscellaneous Housekeeping

> Terraform linting, formatting

```
> terraform validate
> terraform fmt
```

> Update gcloud components

```
> sudo gcloud components update -y
```

> Gcloud Config Setup > Reinitialise with a completely new configuration.

```
gcloud init
```

> Destroy resources created with Terraform

```
terraform destroy -auto-approve
```

</details>
<br>
