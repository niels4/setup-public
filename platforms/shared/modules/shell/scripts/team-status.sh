#!/bin/sh
# Team status TUI display
# Usage: ~/s/team-status.sh

printf '\n'
printf '\033[1;37m  ert-1562-t1\033[0m \033[2m[hands-off] 22m elapsed\033[0m\n'
printf '\033[2m  │\033[0m\n'
printf '\033[1;34m  ├─ planner\033[0m \033[2m(sonnet)\033[0m\n'
printf '\033[2m  │  \033[0m task 1: investigate root cause \033[32m■ completed 4m\033[0m\n'
printf '\033[2m  │  \033[0m task 4: write PR draft \033[33m■ in_progress 2m\033[0m\n'
printf '\033[2m  │\033[0m\n'
printf '\033[1;32m  ├─ engineer\033[0m \033[2m(opus)\033[0m\n'
printf '\033[2m  │  \033[0m task 2: implement fix \033[32m■ completed 8m\033[0m\n'
printf '\033[2m  │  \033[0m\033[32m  ├─ explore-map-panel\033[0m \033[2m· shutdown\033[0m\n'
printf '\033[2m  │  \033[0m\033[32m  ├─ explore-3d-panel\033[0m \033[2m· shutdown\033[0m\n'
printf '\033[2m  │  \033[0m\033[32m  └─ explore-message-pipeline\033[0m \033[2m· shutdown\033[0m\n'
printf '\033[2m  │\033[0m\n'
printf '\033[1;33m  └─ qa\033[0m \033[2m(sonnet)\033[0m\n'
printf '\033[2m     \033[0m task 3: verify fix \033[33m■ in_progress 3m\033[0m\n'
printf '\n'
