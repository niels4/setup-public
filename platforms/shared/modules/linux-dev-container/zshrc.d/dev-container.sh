#!/usr/bin/env bash
DEV_CONTAINER_HOME="${DEV_CONTAINER_HOME:-$HOME/containers/dev}"  # default dev directory
CONTAINER_USER=$(whoami)                    # container user matches host user
CONTAINER_TAG="dev-container"
CONTAINER_NAME="dev"
DEV_CONTAINER_CPUS=7
DEV_CONTAINER_MEMORY="12g"

dev-container-ensure() {
  if [[ ! -f "$DEV_CONTAINER_HOME/Dockerfile" ]]; then
    echo "Error: No Dockerfile found in $DEV_CONTAINER_HOME" >&2
    return 1
  fi
}

dev-container-build() {
  dev-container-ensure || return 1
  cd "$DEV_CONTAINER_HOME" || return 1
  podman build --build-arg USERNAME="$CONTAINER_USER" -t "$CONTAINER_TAG" .
}

dev-start() {
  dev-container-ensure || return 1

  if podman container exists "$CONTAINER_NAME"; then
    if [[ "$(podman inspect -f '{{.State.Status}}' "$CONTAINER_NAME")" != "running" ]]; then
      podman start "$CONTAINER_NAME"
    fi
  else
    podman run -d \
      --name "$CONTAINER_NAME" \
      --hostname "$CONTAINER_NAME" \
      --cpus "$DEV_CONTAINER_CPUS" \
      --memory "$DEV_CONTAINER_MEMORY" \
      --userns=keep-id \
      --user "$(id -u)":"$(id -g)" \
      -p 2222:22 \
      -v "$DEV_CONTAINER_HOME":"/home/$CONTAINER_USER" \
      -v "$SETUP_DIR":"/home/$CONTAINER_USER/setup" \
      "$CONTAINER_TAG"
  fi

  # retry again in half a second if the first ssh fails
  ssh dev 2>/dev/null || { sleep 0.5; ssh dev; }
}

dev-stop() {
  podman stop "$CONTAINER_NAME" 2>/dev/null
}

dev-container-delete() {
  dev-stop
  podman rm "$CONTAINER_NAME" 2>/dev/null
}

dev-reset() {
  dev-container-delete
  dev-container-build
  dev-start
}

dev-container-ip() {
  local ip
  ip=$(podman inspect -f '{{.NetworkSettings.IPAddress}}' "$CONTAINER_NAME" 2>/dev/null)
  if [[ -z "$ip" ]]; then
    return 0
  fi
  echo "$ip"
}

containers-prune() {
  podman container prune -f
  podman image prune -af
}

containers-list() {
  podman ps -a
}
