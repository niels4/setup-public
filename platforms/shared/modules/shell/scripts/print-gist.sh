#!/usr/bin/env zsh

git_user=$1
gist_file=$2

raw_url=$(curl -sL https://api.github.com/users/${git_user}/gists | jq -r ".[].files.\"${gist_file}\".raw_url")

curl "$raw_url"
