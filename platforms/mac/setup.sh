#!/usr/bin/env sh

mac_setup_dir="$(dirname "$(realpath "$0")")"
base_setup_dir="${mac_setup_dir}/../.."

BREW_PREFIX="/opt/homebrew"

# Add brew to path if its installed but not already on the path
if [ -d "$BREW_PREFIX" ] && ! command -v brew >/dev/null 2>&1; then
  export PATH="$BREW_PREFIX/bin:$BREW_PREFIX/sbin:$PATH"
fi

if ! command -v brew >/dev/null 2>&1;then
  echo "'brew' command not found. Visit 'https://brew.sh' to follow installation instructions (copy and paste script)."
  open "https://brew.sh"
  exit 1
fi

# install fnm (fast node manager, similar to nvm)
brew install fnm
eval "$(fnm env)"

# install latest version of nodejs
fnm install --latest
fnm default latest

# install and use version specified in .node-version file to run setup script
fnm install "$(cat "${base_setup_dir}"/.node-version)"
fnm use "$(cat "${base_setup_dir}"/.node-version)"

# cd into setup_dir
pushd "${mac_setup_dir}"

# run setup script
npm install
node setup.ts

# return user back to the directory they were in
popd
