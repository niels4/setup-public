red="\e[31m"
green="\e[32m"
bold="\e[1m"
reset="\e[0m"
checkmark="✓"
cross="✗"

# make sure i don't accidentally print my private key
# as they are both in the ~/.ssh directory with very similar names
alias print-public-key="cat ~/.ssh/id_mykey.pub"

unlock-keyring() {
  eval $(read -rs "pass?Password: "; echo -n "$pass" | gnome-keyring-daemon -r --unlock)
  secret-tool lookup ssh passphrase > /dev/null
  if [[ $? -ne 0 ]]; then
    echo -e "${red}${bold}Failed to unlock keyring!${reset}"
    return 1
  fi
  echo -e "${red}${bold}**********${cross}${cross}${cross}${cross}${cross} Keyring Unlocked! ${cross}${cross}${cross}${cross}${cross}**********${reset}"
}

# lock keyring as described: https://wiki.archlinux.org/title/GNOME/Keyring#Locking_a_keyring
lock-keyring() {
  dbus-send --session --dest=org.freedesktop.secrets \
    --type=method_call  \
    /org/freedesktop/secrets \
    org.freedesktop.Secret.Service.Lock \
    array:objpath:/org/freedesktop/secrets/collection/login
  echo -e "${green}${bold}${checkmar} Keyring locked ${checkmark}${reset}"
}

unlock-ssh() {
  if [[ ! -e "${HOME}/.ssh/id_mykey" ]]; then
    echo "${red}${bold}SSH Key does not exist!${reset}"
    return 1
  fi

  unlock-keyring

  if [[ $? -ne 0 ]]; then
    return 1
  fi

  expect << EOF
  set timeout -1
  spawn ssh-add ${HOME}/.ssh/id_mykey
  expect "Enter passphrase*:"
  send -- "$(secret-tool lookup ssh passphrase)\r"
  expect eof
EOF
  lock-keyring
}
