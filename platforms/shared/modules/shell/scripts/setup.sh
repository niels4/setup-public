#!/usr/bin/env zsh

# exit when any command fails
set -e
# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

SETUP_DIR=${SETUP_DIR:-~/setup}

if ! pushd "$SETUP_DIR" >/dev/null 2>&1; then
  echo "ERROR: Directory ${SETUP_DIR} does not exist. Please check your SETUP_DIR variable (usually set in ~/.zshenv) and make sure your setup repo is checked out at that location."
    exit 1
fi

# make sure git repo is up to date
if [ -d .git ]; then
  git fetch

  if [[ `git status --porcelain` ]]; then
    echo "Local changes in git directory"
  fi

  UPSTREAM=${1:-'@{u}'}
  LOCAL=$(git rev-parse @)
  REMOTE=$(git rev-parse "$UPSTREAM")
  BASE=$(git merge-base @ "$UPSTREAM")

  if [ $LOCAL = $REMOTE ]; then
      echo "Branch Up-to-date"
  elif [ $LOCAL = $BASE ]; then
      echo "Need to pull, branch is behind"
      git pull
  elif [ $REMOTE = $BASE ]; then
      echo "Need to push, branch is ahead"
      git push
  else
      echo "Branch diverged from remote!"
  fi

fi

NODE_VERSION="$(node -v)"

export NODE_VERSION

./setup.sh

popd
