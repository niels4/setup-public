#!/usr/bin/env zsh

# zsh-completions: extra community tab completions
fpath=("${XDG_DATA_HOME}/zsh/plugins/zsh-completions/src" $fpath)

# Make sure our completion colors match our ls colors in both linux and mac
if (( $+commands[dircolors] )); then
  eval "$(dircolors -b)"
else
  export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:st=34;44"
fi

# load completions (cached, use refresh-completions-cache alias to add or update completions)
autoload -Uz compinit && compinit -C

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*' # match from more places in the word
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" "ma=48;5;244;1" # match ls colors, use color 244 to highlight selection background
zstyle ':completion:*' menu yes select # open with a menu
