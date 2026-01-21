#!/usr/bin/env sh

arch_setup_dir=$(dirname "$(realpath "$0")")
base_setup_dir="${arch_setup_dir}/../.."

# ensure nodejs, go, and rust are installed before calling setup
sudo pacman -Sy --needed --noconfirm git base-devel go rustup

# only run this block if yay is NOT on your PATH
if ! which yay >/dev/null 2>&1; then
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
yay -S --needed --noconfirm fnm
eval "$(fnm env)"

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
