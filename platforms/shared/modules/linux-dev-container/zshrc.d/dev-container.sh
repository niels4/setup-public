#!/usr/bin/env zsh
DEV_CONTAINER_HOME="${DEV_DIR:-$HOME/dev}"  # default dev directory
CONTAINER_USER=$(whoami)                    # container user matches host user
CONTAINER_TAG="dev-container"
CONTAINER_NAME="dev"
DEV_CONTAINER_CPUS=7
DEV_CONTAINER_MEMORY="12g"
export DEV_CONTAINER_IP

container-ensure() {
  if [[ ! -f "$DEV_CONTAINER_HOME/Dockerfile" ]]; then
    echo "Error: No Dockerfile found in $DEV_CONTAINER_HOME" >&2
    return 1
  fi

  if ! command -v podman &>/dev/null; then
    echo "Error: Podman is not installed" >&2
    return 1
  fi
}

container-build() {
  container-ensure || return 1
  cd "$DEV_CONTAINER_HOME" || return 1
  podman build --build-arg USERNAME="$CONTAINER_USER" -t "$CONTAINER_TAG" .
}

container-start() {
  container-ensure || return 1

  if podman container exists "$CONTAINER_NAME"; then
    if [[ "$(podman inspect -f '{{.State.Status}}' "$CONTAINER_NAME")" != "running" ]]; then
      podman start "$CONTAINER_NAME"
    fi
  else
    podman run -d \
      --name "$CONTAINER_NAME" \
      --cpus "$DEV_CONTAINER_CPUS" \
      --memory "$DEV_CONTAINER_MEMORY" \
      -v "$DEV_CONTAINER_HOME":"/home/$CONTAINER_USER" \
      "$CONTAINER_TAG" \
      sleep infinity
  fi

  DEV_CONTAINER_IP=$(container-ip)

  ssh dev
}

container-stop() {
  podman stop "$CONTAINER_NAME" 2>/dev/null
}

container-delete() {
  container-stop
  podman rm "$CONTAINER_NAME" 2>/dev/null
}

container-reset() {
  container-delete
  container-build
  container-start
}

container-prune() {
  container-ensure || return 1
  podman container prune -f
  podman image prune -af
}

container-list() {
  podman ps -a
}

container-ip() {
  if ! container-ensure &>/dev/null; then
    return 0
  fi

  local ip
  ip=$(podman inspect -f '{{.NetworkSettings.IPAddress}}' "$CONTAINER_NAME" 2>/dev/null)
  echo "$ip"
}

DEV_CONTAINER_IP=$(container-ip)
