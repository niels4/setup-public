#!/usr/bin/env zsh
set -euo pipefail
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

# install mise for managing nodejs versions
brew install mise
eval "$(mise activate zsh)"

echo 'activated'

# install and use version specified in .node-version file to run setup script
mise shell node@"$(cat "${base_setup_dir}"/.node-version)"

(
  cd "${mac_setup_dir}" || exit 1
  npm install
  node setup.ts
  # Install all your default packages at once
  xargs -r npm install -g < "${MISE_NODE_DEFAULT_PACKAGES_FILE}"
  mise install node@latest # wait until after default-npm-packages-file is created to install latest node
) || exit 1 

exit 0
