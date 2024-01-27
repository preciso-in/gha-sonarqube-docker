#!/bin/bash
trap 'echo "${BASH_SOURCE[0]}: line ${LINENO}: status ${?}: user ${USER}: func ${FUNCNAME[0]}"' ERR
script_dir=$(dirname "$(realpath "$0")")
cd "$script_dir"

################################################################################
#               Create App Resources on GCP with GCloud CLI                    #
#                                                                              #
# This script creates Google Cloud resources for deployment of an HTML Site    #
#                                                                              #
# Requirements:                                                                #
# - node                                                                       #
# - gcloud                                                                     #
#                                                                              #
# Usage: 																																		   #
# ./scripts/create-resources.sh \ 																									 #
#   --use-defaults \ 																												   #
#   --project-id <project-id> \  																							 #
#   --region <region> \ 																											 #
#   --bucket-id <storage-bucket-id> \ 														 #
#                                                                              #
# Change History                                                               #
# 11/01/2024  Nilesh Parkhe   Working script that creates Networks,            #
#                             Firewall rules and VM Servers to deploy a        #
#                             Website to the internet.                         #
#                                                                              #
#                                                                              #
################################################################################
################################################################################
################################################################################
#                                                                              #
#  Copyright (C) 2023, 2024 Nilesh Parkhe                                      #
#                                                                              #
#  This program is free software; you can redistribute it and/or modify        #
#  it under the terms of the GNU General Public License as published by        #
#  the Free Software Foundation; either version 2 of the License, or           #
#  (at your option) any later version.                                         #
#                                                                              #
#  This program is distributed in the hope that it will be useful,             #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of              #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               #
#  GNU General Public License for more details.                                #
#                                                                              #
#  You should have received a copy of the GNU General Public License           #
#  along with this program; if not, write to the Free Software                 #
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA   #
#                                                                              #
################################################################################

# Exit on error
set -e
# Print command before executing
set -x

source ./modules/utils.sh
source ./modules/config.sh

source ./getInputs/process-arguments.sh
handle_arguments $@

source ./working/input-variables.sh

# Read default values
source ./default-values.sh

if [[ "$PROJECT_ID_ARGS" != "[USE_DEFAULT]" ]]; then
	PROJECT_ID="$PROJECT_ID_ARGS"
fi
if [[ "$REGION_ARGS" != "[USE_DEFAULT]" ]]; then
	REGION="$REGION_ARGS"
fi
if [[ "$BUCKET_ID_ARGS" != "[USE_DEFAULT]" ]]; then
	BUCKET_ID="$BUCKET_ID_ARGS"
fi

source ./modules/check-gcp-login.sh

active_account=$(check_active_account)

if [[ -n "$active_account" ]]; then
	print_green "\nYou are currently logged in as $active_account"
else
	print_red "\nYou are not authenticated with gcloud."
	prompt_for_authentication
	active_account=$(check_active_account)
fi

get_billing_account

source ./modules/check-available-projects-quota.sh
check_available_projects_quota

source ./modules/create-project.sh
create_project

source ./modules/update-gcloud-config.sh
update_gcloud_config

source ./modules/create-bucket.sh
create_bucket

source ./modules/enable-compute-api.sh
enable_compute_api

source ./modules/delete-default-firewall-rules.sh
delete_default_firewall_rules

source ./modules/delete-default-network.sh
delete_default_network

# Create TFVars file from input variables
source ./modules/list-resources-created.sh
list_resources_created

source ./modules/update-tf-backend.sh
update_tf_backend

cd ../terraform-config
print_yellow "If you are running this on a completely new project, you might need to clear Terraform cache:"
read -p "Do you want to clear Terraform cache? (y/n) " answer
if [[ "$answer" == "y" ]]; then
	rm -rf .terraform/
	rm .terraform.lock.hcl || {
		print_green "No .terraform.lock.hcl file found. Continuing..."
	}
fi

terraform init --backend-config=backend.hcl || {
	print_red "Terraform init failed. Perhaps you are not authenticated with project: $PROJECT_ID"
	print_yellow "Please authenticate to GCP Project: $Project_ID"
	gcloud auth application-default login

	terraform init --backend-config=backend.hcl || {
		print_red "Terraform init failed again. Exiting..."
		exit 1
	}
}

terraform fmt
terraform validate

terraform apply --auto-approve
