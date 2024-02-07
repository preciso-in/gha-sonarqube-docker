#!/bin/bash
# shellcheck disable=SC2155

printf "\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n"

export PATH="/opt/gradle/bin:/opt/maven/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin:/usr/local/rvm/bin:/google/go_appengine:/google/google_appengine:/google/migrate/anthos/:/home/neellearngcp/.gems/bin:/usr/local/rvm/bin:/home/neellearngcp/gopath/bin:/google/gopath/bin:/google/flutter/bin:/usr/local/nvm/versions/node/v20.11.0/bin"

if command -v gnomon >/dev/null 2>&1; then
  echo "Gnomon is installed."
else
  echo "Gnomon is not installed. Installing gnomon..."
  npm i -g gnomon
fi

export PATH=$PATH:$(pwd)/act/bin

cd gha/gha-sonarqube-docker || exit 1
git fetch --all
git reset --hard origin/setup-act

act -j lint -p false -s GITHUB_TOKEN="$(gh auth token)" | gnomon

printf "\n\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n"
