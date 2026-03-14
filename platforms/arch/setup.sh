#!/usr/bin/env zsh
set -euo pipefail

arch_setup_dir=$(dirname "$(realpath "$0")")
base_setup_dir="${arch_setup_dir}/../.."

. "$base_setup_dir/platforms/shared/base-vars.sh"
. "$arch_setup_dir/Packagefile"

sudo pacman --needed --noconfirm -Syu $PACMAN_PACKAGES

if ! cargo --version >/dev/null 2>&1; then
  rustup default stable
fi

if ! command -v paru >/dev/null 2>&1; then
  (
    git clone https://aur.archlinux.org/paru.git "$XDG_DATA_HOME/paru"
    cd "$XDG_DATA_HOME/paru"
    makepkg -si --noconfirm
  )
fi

paru --needed --noconfirm -S $AUR_PACKAGES

# install mise for managing nodejs versions
if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
fi

eval "$(mise activate zsh)"

# install and use version specified in .node-version file to run setup script
mise shell node@"$(cat "${base_setup_dir}"/.node-version)"

# ensure this file exists (needed by the setup)
touch ~/.zshenv

# run setup script in arch_setup_dir
(
  cd "${arch_setup_dir}" || exit 1
  npm install
  node setup.ts
  # Install all your default packages at once
  xargs npm install -g < "${MISE_NODE_DEFAULT_PACKAGES_FILE}"
  mise install node@latest # wait until after default-npm-packages-file is created to install latest node
) || exit 1 

exit 0
