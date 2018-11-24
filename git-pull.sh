#!/bin/bash
set -euo pipefail
git pull ${@} && \
git l $(echo $(git reflog | grep -A1 pull | head -2 | grep -Eo '^[a-zA-Z0-9]+' | sort -r) | sed 's# #..#g')
