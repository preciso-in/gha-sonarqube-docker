# Cleaning up Resources Created

---

<details>

<summary>Clean up resources completely</summary>

```
> cd scripts
> export PATH=$PATH:${pwd}
> tf-destroy.sh
```

You can choose whether to delete project and bucket. If you delete project and bucket, you will have to change defaults or specify their values when running tf-create.sh

</details>

---

<details>

<summary>Clean up resources created by Terraform</summary>

```
> cd terraform-config
> terraform destroy --auto-approve
```

This will not remove project and storage bucket created by the script. Thus there is no update required in defaults.

</details>
