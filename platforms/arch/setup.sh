#!/usr/bin/env sh

setup_dir=$(dirname "$(realpath "$0")")

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

# install fnm and latest version of nodejs
yay -S --needed --noconfirm fnm

fnm install --latest
fnm default latest
eval "$(fnm env --use-on-cd)"

# run setup script
pushd "${setup_dir}"

npm install
node setup.ts

popd
