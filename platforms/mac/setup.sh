#!/usr/bin/env sh

setup_dir=$(dirname "$(realpath "$0")")

if ! command -v brew >/dev/null 2>&1;then
  echo "'brew' command not found. Visit 'https://brew.sh' to follow installation instructions (copy and paste script)."
  open "https://brew.sh"
  exit 1
fi

# install latest version of nodejs
brew install fnm
fnm install --latest
fnm default latest
eval "$(fnm env --use-on-cd)"

pushd "${setup_dir}"

# run setup script
npm install
node setup.ts

popd
