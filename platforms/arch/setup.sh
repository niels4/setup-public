#!/usr/bin/env sh

arch_setup_dir=$(dirname "$(realpath "$0")")
base_setup_dir="${arch_setup_dir}/../.."

# ensure nodejs, go, and rustup are installed before calling setup
sudo pacman -Sy --needed --noconfirm git base-devel go unzip

if ! command -v cargo >/dev/null 2>&1;then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
fi
. "${HOME}/.local/share/cargo/env"

# only run this block if yay is NOT on your PATH
if ! command -v yay >/dev/null 2>&1;then
  echo "Installing yay AUR helper…"
  pushd /tmp
  if [ ! -d "yay" ]; then
    git clone https://aur.archlinux.org/yay.git
  fi
  pushd yay
  makepkg -si --noconfirm
  popd
  popd
fi

# install fnm (fast node manager, similar to nvm)
if [ ! -d "$FNM_PATH" ]; then
  curl -fsSL https://fnm.vercel.app/install | bash
fi

FNM_PATH="${HOME}/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
else
  echo "FNM install failed. Exiting setup"
  exit 1
fi

# install latest version of nodejs
fnm install --latest
fnm default latest
#
# install and use version specified in .node-version file to run setup script
fnm install "$(cat "${base_setup_dir}"/.node-version)"
fnm use "$(cat "${base_setup_dir}"/.node-version)"

# cd into setup_dir
pushd "${arch_setup_dir}"

# run setup script
npm install
node setup.ts

# return user back to the directory they were in
popd
