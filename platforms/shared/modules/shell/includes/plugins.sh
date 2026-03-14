#!/usr/bin/env zsh

# zsh-syntax-highlighting: colors commands as you type
zstyle ':bracketed-paste-magic' active-widgets '.self-*'
source "${XDG_DATA_HOME}/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# zsh-autosuggestions: inline history suggestions
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
source "${XDG_DATA_HOME}/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
