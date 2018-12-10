#!/bin/bash
set -euxo pipefail

if ! git checkout ${1}; then
  git fetch origin
  git checkout -t -b ${1} origin/${1}
  git diff --summary ${1}..master
fi
