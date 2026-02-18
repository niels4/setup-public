#!/usr/bin/env zsh
# zoxide
_zo_exclude=(
  "*/node_modules"
  "*/.git"
  "*/dist"
  "*/build"
)
export _ZO_EXCLUDE_DIRS="${(j.:.)_zo_exclude}"
eval "$(zoxide init zsh --cmd cd)"

# bat
if command -v batcat >/dev/null 2>&1; then
  _fzf_bat="batcat"
elif command -v bat >/dev/null 2>&1; then
  _fzf_bat="bat"
else
  _fzf_bat="cat"
fi
export BAT_THEME="ansi"

# fzf
export FZF_TMUX_OPTS=" -p90%,70% "

_fzf_walker_skip=(
  .git
  node_modules
  dist
  build
  coverage
  .next
  .cache
  __pycache__
  .mypy_cache
  target
)
_fzf_walker_skip="${(j:,:)_fzf_walker_skip}"

export FZF_CTRL_T_OPTS="
  --walker-skip ${_fzf_walker_skip}
  --preview \"if [ -d {} ]; then tree -C -L 2 {}; else ${_fzf_bat} --color=always -n --paging=never --line-range :500 {}; fi\""

export FZF_ALT_C_OPTS="
  --walker-skip ${_fzf_walker_skip}
  --preview 'tree -C -L 2 {}'"

eval "$(fzf --zsh)"

# mise
eval "$(mise activate zsh --shims)"
