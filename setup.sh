#!/usr/bin/env sh

setup_dir=$(dirname "$(realpath "$0")")

echo "SETUP DIR: ${setup_dir}"

. "${setup_dir}/platforms/shared/base-vars.sh"

if [ "$(uname)" = "Darwin" ]; then
  echo "Platform is mac"
  "${setup_dir}/platforms/mac/setup.sh"

elif [ -f /etc/os-release ] && grep -iq "omarchy" /etc/os-release; then
  echo "Platform is omarchy"
  "${setup_dir}/platforms/omarchy/setup.sh"

elif pacman -h > /dev/null 2>&1; then
  echo "Platform is arch"
  sudo pacman -Sy --needed --noconfirm zsh
  "${setup_dir}/platforms/arch/setup.sh"

elif apt-get -h > /dev/null 2>&1; then
  # The only place I use debian is in the container
  # You will need to make this more specific if you use debian or ubuntu as a host OS
  echo "Platform is dev-container"
  "${setup_dir}/platforms/dev-container/setup.sh"

else
  echo "Unsupported Platform!"
  exit 1
fi
