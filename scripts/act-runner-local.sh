#!/bin/bash

if command -v gnomon >/dev/null 2>&1; then
  echo "Gnomon is installed."
else
  echo "Gnomon is not installed."
  npm i -g gnomon
fi

if command -v act >/dev/null 2>&1; then
  echo "Act is installed."
  act -j lint -p false -s GITHUB_TOKEN="$(gh auth token)" | gnomon
else
  echo "Act is not installed."
  echo "Install act"
fi
