#!/bin/sh

setup_dir=$(dirname "$(realpath "$0")")


if [ ! -d /opt/homebrew ];then

  echo "Enter user password to install homebrew:"
  IFS= read -rs USER_PW
  sudo -k # clear sudo credentials
  if echo "$USER_PW" | sudo -S -v &> /dev/null; then
    echo "\nPassword confirmed."
  else
    echo "\nInvalid password."
    sudo -k
    exit 1
  fi
  sudo -k # clear sudo credentials

  homebrew_install_script="/tmp/homebrew_install.sh"
  echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"' > ${homebrew_install_script}
  chmod +x ${homebrew_install_script}

  expect << EOF
set timeout -1
spawn ${homebrew_install_script}

expect "Password:"
send -- "$USER_PW\r"

expect -re {to continue or any other key to abort:\r\n$}
send -- "\r"

expect eof
EOF

  USER_PW=""

  echo "Homebrew installed, run brew doctor to verify"
fi

# add homebrew to the path
eval "$(/opt/homebrew/bin/brew shellenv)"

# install latest version of nodejs
brew install fnm
eval "$(fnm env --use-on-cd)"
fnm install --latest
fnm default latest

pushd ${setup_dir}

# run setup script
npm install
node setup.ts

popd
