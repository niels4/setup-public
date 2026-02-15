# this Dockerfile handles everything outside of the home directory
# the home directory is persisted between builds and shared with the host machine, usually located at ~/dev on the host machine
# the home directory is setup and managed by the home dir setup script, usually located at ~/setup/setup.sh on the container (~/dev/setup/setup.sh on the host machine)

FROM debian:stable-slim

# Override with your own username: container build --build-arg USERNAME=$(whoami) --tag dev-container .
ARG USERNAME=niels

# Package categoreies
ARG CORE="locales sudo less vim-tiny nano procps tree expect ca-certificates curl wget unzip"
ARG DOCS="man-db manpages manpages-dev info doc-debian"
ARG SSH_TOOLS="openssh-client openssh-server keychain pass gnupg"
ARG GIT_TOOLS="git git-lfs gh"
ARG SHELL_TOOLS="zsh tmux fzf ripgrep fd-find jq direnv zoxide bat shellcheck"
ARG CONTAINER_TOOLS="podman"
ARG GO_TOOLS="golang"
ARG RUST_TOOLS="rustup"
ARG PYTHON_TOOLS="python3 pipx"
ARG LUA_TOOLS="luajit"
# Nodejs is installed in the home dir setup script

RUN apt-get update && apt-get install -y \
      $CORE \
      $DOCS \
      $SSH_TOOLS \
      $GIT_TOOLS \
      $SHELL_TOOLS \
      $CONTAINER_TOOLS \
      $GO_TOOLS \
      $RUST_TOOLS \
      $PYTHON_TOOLS \
      $LUA_TOOLS

# Set locale to en utf8
RUN sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Populate man page database
RUN mandb

# Install and Populate tealdeer cache (tldr cli app)
RUN curl -fsSL https://github.com/tealdeer-rs/tealdeer/releases/latest/download/tealdeer-linux-aarch64-musl \
  -o /usr/local/bin/tldr \
  && chmod +x /usr/local/bin/tldr \
  && TEALDEER_CACHE_DIR=/usr/local/share/tealdeer tldr --update \
  && chmod -R a+rwX /usr/local/share/tealdeer

ENV TEALDEER_CACHE_DIR=/usr/local/share/tealdeer

# install treesitter-cli (used by neovim)
RUN curl -fsSL https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-arm64.gz \
  | gunzip > /usr/local/bin/tree-sitter \
  && chmod +x /usr/local/bin/tree-sitter

# install latest version of neovim
RUN curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz \
  | tar -C /opt -xz \
  && ln -s /opt/nvim-linux-arm64/bin/nvim /usr/local/bin/nvim

# Configure sshd: key-only auth, no root login
RUN <<EOF cat > /etc/ssh/sshd_config.d/00-container.conf
Port 22
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
X11Forwarding no
AllowUsers ${USERNAME}
EOF

# Entrypoint starts sshd then exec's the CMD
RUN <<'EOF' cat > /usr/local/bin/entrypoint.sh
#!/bin/sh
sudo mkdir -p /run/sshd
sudo /usr/sbin/sshd
exec "$@"
EOF
RUN chmod +x /usr/local/bin/entrypoint.sh

# Create user with empty home directory and zsh as login shell.
# Home directory is setup and managed by a post install setup script and persisted between builds
# Allow user to use sudo
RUN useradd -m -k /dev/null -s /bin/zsh $USERNAME
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME

# Start ssh server on system startup
ENTRYPOINT ["entrypoint.sh"]

# Default to zsh to be consistent with mac shell
CMD ["/bin/zsh"]
