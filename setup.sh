#!/bin/sh

setup_dir=$(dirname "$(realpath "$0")")

echo "SETUP DIR: ${setup_dir}"

if [ "$(uname)" = "Darwin" ]; then
  echo "Platform is mac"
  "${setup_dir}/platforms/mac/setup.sh"

elif pacman -h > /dev/null 2>&1; then
  echo "Platform is arch"
  "${setup_dir}/platforms/arch/setup.sh"

else
  echo "Unsupported Platform!"
  exit 1
fi
