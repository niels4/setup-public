clean-nvim-data() {
  rm -rf "$XDG_DATA_HOME/nvim"
  rm -rf "$XDG_STATE_HOME/nvim"
  rm "$XDG_CONFIG_HOME/nvim/lazy-lock.json"
}
