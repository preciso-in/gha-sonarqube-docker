create_terraform_vars() {
    RESOURCE_NAMES="
  	  PROJECT_ID
      REGION
      NETWORK_NAME
      SUBNET_NAME
      BUCKET_ID
      INSTANCE_TEMPLATE_NAME
      JENKINS_INSTANCE_NAME
      DOCKER_INSTANCE_NAME
      SONARQUBE_INSTANCE_NAME
      JENKINS_NETWORK_TAG
      SONARQUBE_NETWORK_TAG
      DOCKER_NETWORK_TAG
    "

    >../terraform-config/terraform.tfvars

    for var in $RESOURCE_NAMES; do
        lowercase_var=$(echo "$var" | tr '[:upper:]' '[:lower:]')
        echo "$lowercase_var = \"${!var}\"" >>../terraform-config/terraform.tfvars
    done
}

create_delete_resources_script_vars() {
    DELETE_RESOURCE_NAMES="
  	  PROJECT_ID
      BUCKET_ID
    "
    >./modules/working/delete-resources-vars.sh

    for var in $DELETE_RESOURCE_NAMES; do
        echo "export $var=${!var}" >>../scripts/modules/working/delete-resources-vars.sh
    done
}

list_resources_created() {
    create_terraform_vars
    create_delete_resources_script_vars
}
