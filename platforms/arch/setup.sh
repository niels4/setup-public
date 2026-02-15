#!/usr/bin/env zsh
set -euo pipefail

arch_setup_dir=$(dirname "$(realpath "$0")")
base_setup_dir="${arch_setup_dir}/../.."

. $base_setup_dir/platforms/shared/base-vars.sh

# ensure nodejs, go, and rustup are installed before calling setup
sudo pacman -Sy --needed --noconfirm git base-devel go unzip rustup

if ! cargo --version >/dev/null 2>&1; then
  rustup default stable
fi

if ! command -v paru >/dev/null 2>&1; then
  (
    git clone https://aur.archlinux.org/paru.git $XDG_DATA_HOME/paru
    cd $XDG_DATA_HOME/paru
    makepkg -si --noconfirm
  )
fi

# install mise for managing nodejs versions
if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
fi

eval "$(mise activate zsh)"

# install and use version specified in .node-version file to run setup script
mise shell node@"$(cat "${base_setup_dir}"/.node-version)"

# run setup script in arch_setup_dir
(
  cd "${arch_setup_dir}" || exit 1
  npm install
  node setup.ts
  # Install all your default packages at once
  xargs -r npm install -g < "${MISE_NODE_DEFAULT_PACKAGES_FILE}"
  mise install node@latest # wait until after default-npm-packages-file is created to install latest node
) || exit 1 

exit 0
