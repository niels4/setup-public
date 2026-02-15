#!/usr/bin/env zsh

arch_setup_dir=$(dirname "$(realpath "$0")")
base_setup_dir="${arch_setup_dir}/../.."

# ensure nodejs, go, and rustup are installed before calling setup
sudo pacman -Sy --needed --noconfirm git base-devel go unzip

if ! command -v cargo >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
fi
. "${HOME}/.local/share/cargo/env"

# only run this block if paru is NOT on your PATH
if ! command -v paru >/dev/null 2>&1; then
  echo "Installing paru AUR helper…"
  paru_build_dir="/tmp/paru"
  if [ ! -d "$paru_build_dir" ]; then
    git clone https://aur.archlinux.org/paru.git "$paru_build_dir"
  fi
  (cd "$paru_build_dir" && makepkg -si --noconfirm)
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
