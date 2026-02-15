# run rzsh to reload all zsh instances
alias rzsh="killall -USR1 zsh || true; killall -USR1 -- -zsh || true"

# trap to reload all zsh instances
TRAPUSR1() {
  if [[ -o INTERACTIVE ]]; then
     {echo; echo "execute a new shell instance" } 1>&2
     source ~/.zshenv
     exec /bin/zsh
  fi
}
