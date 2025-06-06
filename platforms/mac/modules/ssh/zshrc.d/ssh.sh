# just some convenient aliases to make sure i don't accidentally copy or print my private key
# as they are both in the ~/.ssh directory with very similar names
alias print-public-key="cat ~/.ssh/id_mykey.pub"

alias copy-public-key="pbcopy < ~/.ssh/id_mykey.pub"
