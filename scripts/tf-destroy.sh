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
# set -x

#TODO: Simple script that checks if TF is installed, gcloud is authorized and then destroys the resources created.

source ./modules/utils.sh
source ./modules/config.sh

source ./modules/check-gcp-login.sh

active_account=$(check_active_account)

if [[ -n "$active_account" ]]; then
	print_green "\nYou are currently logged in as $active_account"
else
	print_red "\nYou are not authenticated with gcloud."
	prompt_for_authentication
	active_account=$(check_active_account)
fi

cd ../terraform-config

terraform destroy -auto-approve

print_green "\nTerraform Resources destroyed successfully."

cd ../scripts

source ./modules/working/delete-resources-vars.sh

source ./modules/delete-bucket.sh
delete_bucket

source ./modules/delete-project.sh
delete_project

print_green "\nResources deleted successfully."
