DEV_CONTAINER_HOME="${DEV_DIR:-$HOME/dev}" # default to mounting ~/dev as the home directory of the container
CONTAINER_USER=$(whoami) # container user matches host user
CONTAINER_TAG=dev-container
CONTAINER_NAME=dev
DEV_CONTAINER_CPUS=7
DEV_CONTAINER_MEMORY=12g
export DEV_CONTAINER_IP


container-ensure() {
  if [[ ! -f "$DEV_CONTAINER_HOME/Dockerfile" ]]; then
    echo "Error: No Dockerfile found in $DEV_CONTAINER_HOME" >&2
    return 1
  fi
  if ! container system status &>/dev/null; then
    echo "y" | container system start
  fi
}

container-build() {
  container-ensure || return 1
  cd "$DEV_CONTAINER_HOME" || return 1
  container build --build-arg USERNAME="$CONTAINER_USER" --tag "$CONTAINER_TAG" .
  container stop buildkit # we can stop the build container when we are done building
}

container-start() {
  container-ensure || return 1
  # If container exists, start it (if stopped) and attach
  if container list --all | grep -q "$CONTAINER_NAME"; then
    container start "$CONTAINER_NAME" 2>/dev/null
  else
    # Create a new named container
    container run -d \
      --name "$CONTAINER_NAME" \
      --cpus "$DEV_CONTAINER_CPUS" \
      --memory "$DEV_CONTAINER_MEMORY" \
      -v "$DEV_CONTAINER_HOME":"/home/$CONTAINER_USER" \
      "$CONTAINER_TAG" \
      sleep infinity
  fi
  DEV_CONTAINER_IP=$(container-ip)

  # container exec -it "$CONTAINER_NAME" /bin/zsh # use this to launch an interactive shell without using ssh
 
  # use ssh instead of exec -it, its less glitchy when using tmux and enables local port forwarding
  ssh dev
}

container-stop() {
  container stop "$CONTAINER_NAME" 2>/dev/null
}

container-delete() {
  container-stop
  container rm "$CONTAINER_NAME" 2>/dev/null
}

container-reset() {
  container-delete
  container-build
  container-start
}

container-prune() {
  container-ensure || return 1
  container prune
  container image prune --all
}

container-list() {
  container list --all
}

container-ip() {
  if ! container system status &>/dev/null; then
    return 0
  fi
  local ip
  ip=$(container list | awk '/^dev / {print $6}' | cut -d/ -f1)
  if [[ -z "$ip" ]]; then
    return 0
  fi
  echo "$ip"
}
DEV_CONTAINER_IP=$(container-ip)
