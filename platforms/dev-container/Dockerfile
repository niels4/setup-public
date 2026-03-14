# this Dockerfile handles everything outside of the home directory
# the home directory is persisted between builds and shared with the host machine, usually located at ~/dev on the host machine
# the home directory is setup and managed by the home dir setup script, usually located at ~/setup/setup.sh on the container (~/dev/setup/setup.sh on the host machine)

FROM debian:stable-slim

# Override with your own username: container build --build-arg USERNAME=$(whoami) --tag dev-container .
ARG USERNAME=dev

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

# Generate locales and set to to en_US.UTF-8
RUN sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen && locale-gen

# set global environment variables for all users on container
RUN cat <<EOF >> /etc/environment
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
TEALDEER_CACHE_DIR=/usr/local/share/tealdeer
EOF

# Populate man page database
RUN mandb

# Manually install binaries where we want the latest version or they aren't in the debian package repos
# Change install urls based on target platform
RUN ARCH=$(uname -m) && \
    case "$ARCH" in \
        x86_64) \
            TEAL_ARCH=x86_64; \
            TS_ARCH=x64; \
            NVIM_ARCH=x86_64 \
        ;; \
        aarch64) \
            TEAL_ARCH=aarch64; \
            TS_ARCH=arm64; \
            NVIM_ARCH=arm64 \
        ;; \
        *) \
            echo "Unsupported architecture: $ARCH"; \
            exit 1 \
        ;; \
    esac && \
    \
    # ---- tealdeer ---- \
    curl -fsSL \
      https://github.com/tealdeer-rs/tealdeer/releases/latest/download/tealdeer-linux-${TEAL_ARCH}-musl \
      -o /usr/local/bin/tldr && \
    chmod +x /usr/local/bin/tldr && \
    TEALDEER_CACHE_DIR=/usr/local/share/tealdeer tldr --update && \
    chmod -R a+rwX /usr/local/share/tealdeer && \
    \
    # ---- tree-sitter ---- \
    curl -fsSL \
      https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-${TS_ARCH}.gz \
      | gunzip > /usr/local/bin/tree-sitter && \
    chmod +x /usr/local/bin/tree-sitter && \
    \
    # ---- neovim ---- \
    curl -fsSL \
      https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz \
      | tar -C /opt -xz && \
    ln -s /opt/nvim-linux-${NVIM_ARCH}/bin/nvim /usr/local/bin/nvim

# Configure ssh server: key-only auth, no root login
RUN <<EOF cat > /etc/ssh/sshd_config.d/00-container.conf
Port 22
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
X11Forwarding no
AllowUsers ${USERNAME}
EOF

# Entrypoint starts sshd in foreground mode to keep the instance running as long as ssh server is running
RUN <<'EOF' cat > /usr/local/bin/entrypoint.sh
#!/bin/sh
sudo mkdir -p /run/sshd
sudo /usr/sbin/sshd -D
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
