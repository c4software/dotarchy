#!/bin/bash

INIT_SCRIPTS=(
  "./install/bootstrap.sh"
  "./install/git.sh"
  "./install/nvim.sh"
)

for script in "${INIT_SCRIPTS[@]}"; do
  (
    source "$script"
    setup
  )
done

