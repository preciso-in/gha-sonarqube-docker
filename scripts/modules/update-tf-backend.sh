update_tf_backend() {
	print_yellow "\nCreating backend.hcl file from input variables"

	if grep -q "bucket" ../terraform-config/backend.hcl; then
		# If bucket_id exists, replace its value
		sed -i ".bak" "s/bucket = .*/bucket = \"$BUCKET_ID\"/" ../terraform-config/backend.hcl
	else
		# If bucket_id does not exist, append it to the file
		echo "bucket = \"$BUCKET_ID\"" >>../terraform-config/backend.hcl
	fi

	rm ../terraform-config/backend.hcl.bak
}
