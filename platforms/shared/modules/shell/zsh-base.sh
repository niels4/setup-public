#!/usr/bin/env zsh
# prompt
setopt prompt_subst

_git_branch() {
  local branch
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || return
  echo " on %F{green}${branch}%f"
}

PROMPT='[%F{red}%n%f@%F{magenta}%m%f:%F{blue}%~%f$(_git_branch)]
%# '
RPROMPT='%(?..%F{red}%? ↵%f)'

# history
HISTSIZE=10000                     # commands kept in memory
HISTFILE="${ZDOTDIR}/.zsh_history" # history file location
SAVEHIST=$HISTSIZE                 # commands written to disk
setopt sharehistory                # sync history across sessions
setopt hist_ignore_space           # leading space excludes from history
setopt hist_ignore_all_dups        # remove older duplicate entries
setopt hist_save_no_dups           # deduplicate when writing to file
setopt hist_find_no_dups           # skip duplicates in search results
setopt EXTENDED_HISTORY            # save timestamps and duration
setopt HIST_REDUCE_BLANKS          # normalize whitespace before saving
unsetopt HIST_BEEP                 # no beep at history boundaries
setopt HIST_NO_STORE               # don't save history command itself

# navigation
setopt auto_cd
