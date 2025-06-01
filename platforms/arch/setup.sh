#!/bin/sh

setup_dir=$(dirname "$(realpath "$0")")

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME=${HOME}/.local/state
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_CONFIG_HOME}/rustup"

# base dev packages
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

eval "$(fnm env --use-on-cd)"

fnm install --latest
fnm default latest

# run setup script
pushd ${setup_dir}

npm install
node setup.ts

popd
