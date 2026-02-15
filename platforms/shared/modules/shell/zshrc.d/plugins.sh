# zoxide, replace cd command
eval "$(zoxide init zsh --cmd cd)"

# fzf
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_TMUX_OPTS=" -p90%,70% "
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
eval "$(fzf --zsh)"

# zinit
zstyle ':omz:alpha:lib:git' async-prompt no

# Must Load OMZ Git library
zinit snippet OMZL::git.zsh

zinit cdclear -q # <- forget completions provided up to this moment

# use oh-my-zsh kphoen theme
setopt promptsubst
zinit snippet OMZT::kphoen

# add plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
# zinit light Aloxaf/fzf-tab
# zinit snippet OMZP::archlinux
# zinit snippet OMZP::aws
# zinit snippet OMZP::kubectl
# zinit snippet OMZP::kubectx

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# history
HISTSIZE=10000
HISTFILE="${ZDOTDIR}/.zsh_history"
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt auto_cd

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}' "ma=48;5;244;1"
zstyle ':completion:*' menu yes select
