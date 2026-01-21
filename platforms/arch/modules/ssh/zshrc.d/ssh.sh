# use keychain as the ssh-agent
# set SSH_AUTH_SOCK and SSH_AGENT_PID using keychain
mkdir -p "${XDG_STATE_HOME}/keychain"
chmod -R go-rwx "${XDG_STATE_HOME}/keychain"
eval $(keychain --quiet --dir "${XDG_STATE_HOME}/keychain" --eval)

gpg_pass_key=$(cat $PASSWORD_STORE_DIR/.gpg-id)
ssh_private_key_file="$HOME/.ssh/id_mykey"
ssh_public_key_file="${ssh_private_key_file}.pub"

red="\e[31m"
green="\e[32m"
bold="\e[1m"
reset="\e[0m"
checkmark="✓"
cross="✗"

# make sure i don't accidentally print my private key
# as they are both in the ~/.ssh directory with very similar names
alias print-public-key="cat ${ssh_public_key_file}"

unlock-password-store() {
  # create a dummy value to retrieve so that we trigger the gpg unlock TUI to show up
  dummy_key="pass/dummy-unlock-value"
  pass insert -m -f "$dummy_key" <<< "unlock"
  pass "${dummy_key}"

  if [[ $? -ne 0 ]]; then
    echo -e "${red}${bold}Failed to unlock keyring!${reset}"
    return 1
  fi
  echo -e "${red}${bold}**********${cross}${cross}${cross}${cross}${cross} Keyring Unlocked! ${cross}${cross}${cross}${cross}${cross}**********${reset}"

  unset dummy_key
}

lock-password-store() {
  gpgconf --kill gpg-agent
  echo -e "${green}${bold}${checkmar} Keyring locked ${checkmark}${reset}"
}

# uses gpg-agent TUI to enter gpg passphrase (defaults to same as user login password)
# will automatically lock password-store after using it
unlock-ssh() {
  if [[ ! -e "${ssh_private_key_file}" ]]; then
    echo "${red}${bold}SSH Key does not exist!${reset}"
    return 1
  fi

  unlock-password-store
  if [[ $? -ne 0 ]]; then
    return 1
  fi

  expect <<EOF 2>/dev/null
set timeout -1
spawn ssh-add ${ssh_private_key_file}
expect "Enter passphrase*:"
send -- "$(pass ssh/passphrase)\r"
expect eof
EOF

  if [[ $? -ne 0 ]]; then
    echo "${red}${bold}ssh unlock failed.${reset}"
  else
    echo "${green}${bold}ssh unlocked.${reset}"
  fi

lock-password-store
}

# use this to change your password-store password independent of your login password
# if your password-store password is different from user password, the change-all-passwords function will no longer work
alias change-password-store-password="gpg --change-passphrase $gpg_pass_key"

# script to read in and verify the user password
alias read-user-password="NODE_NO_WARNINGS=1 $SETUP_DIR/platforms/shared/bin/read-user-password.ts"

# script to read in password twice and verify it matches
alias read-new-password="NODE_NO_WARNINGS=1 $SETUP_DIR/platforms/shared/bin/read-new-password.ts"

# use this to change your user password and password-store password at the same time
change-all-passwords() {
  old_passphrase=$(read-user-password "Enter old password: ")
  echo
  new_passphrase=$(read-new-password "Enter new password: ")


  # Change password-store password
  expect <<EOF 2>/dev/null
set timeout -1
spawn gpg --pinentry-mode loopback --change-passphrase "$gpg_pass_key"
expect "Enter passphrase: "
send "${old_passphrase}\r"
expect "Enter passphrase: "
send "${new_passphrase}\r"
expect "Enter passphrase: "
send "${new_passphrase}\r"
expect eof
EOF

  # for some reason an exit code of 1 means the password was succefully reset and 0 means it wasn't
  if [[ $? -ne 0 ]]; then
    echo "${green}${bold}Password-store password updated.${reset}"
  else
    echo "${red}${bold}Failed to update password-store password.${reset}"
  fi

  # change user password
  expect <<EOF 2>/dev/null
set timeout -1
spawn passwd
expect "Current password: "
send "${old_passphrase}\r"
expect "New password: "
send "${new_passphrase}\r"
expect "Retype new password: "
send "${new_passphrase}\r"
expect eof
EOF

  if [[ $? -ne 0 ]]; then
    echo "${red}${bold}Failed to update user password.${reset}"
  else
    echo "${green}${bold}User password updated.${reset}"
  fi

  unset old_passphrase
  unset new_passphrase
}
