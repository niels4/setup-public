#!/usr/bin/env zsh

container_setup_dir=$(dirname "$(realpath "$0")")
base_setup_dir="${container_setup_dir}/../.."

# ensure this file exists
touch ~/.zshenv

# install mise for managing nodejs versions
if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
fi

eval "$(mise activate zsh)"

# install and use version specified in .node-version file to run setup script
mise shell node@"$(cat "${base_setup_dir}"/.node-version)"

(
  cd "${container_setup_dir}" || exit 1
  npm install
  node setup.ts
  # Install all your default packages at once
  xargs -r npm install -g < "${MISE_NODE_DEFAULT_PACKAGES_FILE}"
  mise install node@latest # wait until after default-npm-packages-file is created to install latest node
) || exit 1 

exit 0
