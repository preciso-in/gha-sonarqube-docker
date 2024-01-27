update_tf_variables() {
	print_yellow "\Updating terraform.tfvars file from input variables"

	if grep -q "project_id" ../terraform-config/terraform.tfvars; then
		# If project_id exists, replace its value
		sed -i ".bak" "s/project_id = .*/project_id = \"$PROJECT_ID\"/" ../terraform-config/terraform.tfvars
	else
		# If project_id does not exist, append it to the file
		echo "project_id = \"$PROJECT_ID\"" >>../terraform-config/terraform.tfvars
	fi

}
