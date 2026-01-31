export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"

export GOPATH="${XDG_DATA_HOME}/go"

case ":$PATH:" in
  *":$GOPATH/bin:"*) ;;
  *) PATH="$GOPATH/bin:$PATH" ;;
esac

export RUSTUP_HOME="${XDG_CONFIG_HOME}/rustup"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"

case ":$PATH:" in
  *":$CARGO_HOME/bin:"*) ;;
  *) PATH="$CARGO_HOME/bin:$PATH" ;;
esac

export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"

export PATH
