#!/bin/bash
set -euo pipefail

slugify_path() {
    local path="$1"
    # Remove leading ./ if any
    path="${path#./}"
    # Replace all / with __
    path="${path//\//__}"
    echo "$path"
}


files="$(tagfind.sh "$@")"
dir="$(mktemp -d -p .)"

# Iterate safely over filenames
while IFS= read -r f; do
  slug=$(slugify_path "$f")
  ln -rsv "$f" "$dir/$slug"
done <<< "$files"

gwenview "$dir/"

# safety check
if [[ "$dir" == *tmp* ]]; then
  rm -rfv "$dir"
fi
