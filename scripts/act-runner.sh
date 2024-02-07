#!/bin/bash
# shellcheck disable=SC2155

cd scripts || exit 1

if [ "$(sysctl -n machdep.cpu.brand_string)" == "Apple M1 Pro" ]; then
  echo "Mac M1 detected. Starting act runner on GCP Cloud Shell."
  gcloud cloud-shell ssh <act-runner-gcp-cloud-shell.sh
else
  echo "Starting act runner on local machine"
  sh act-runner-local.sh
fi
