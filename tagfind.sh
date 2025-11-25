#!/bin/bash


# takes a csv of tags, eg: "alex,house" and a test to see if a match is there. Eg:
# matchtag "alex,house,lily" lily -> 0 (true)
# matchtag "alex,house,lily" loly -> 1 (false)
# matchtag "alex,house,lily" -lily -> 1 (false)  # look for tags NOT containing "lily"
# matchtag "alex,house,lily" alex nope -> 0 (true)  # OR
# matchtag "alex,house,lily" alex+nope -> 1 (false) # AND
# matchtag "alex,house,lily" alex+nope alex+house -> 0 (true) # a and b OR a and c
matchtag() {
    local csv="$1"; shift
    local -a args=("$@")
    local -a exclude=()
    local -a or_groups=()

    # Separate exclude (-tag) and OR groups
    for item in "${args[@]}"; do
        if [[ "$item" == -* ]]; then
            exclude+=("${item:1}")
        else
            or_groups+=("$item")
        fi
    done

    # Convert CSV → set
    IFS=',' read -r -a tag_arr <<< "$csv"
    declare -A tagset=()
    for t in "${tag_arr[@]}"; do
        t="${t#"${t%%[![:space:]]*}"}"   # trim left
        t="${t%"${t##*[![:space:]]}"}"   # trim right
        tagset["$t"]=1
    done

    # Check excludes first
    for bad in "${exclude[@]}"; do
        [[ -n "${tagset[$bad]}" ]] && return 1
    done

    # If no OR groups → match everything not excluded
    [[ ${#or_groups[@]} -eq 0 ]] && return 0

    # Evaluate OR groups: each group is AND of +-separated tags
    for group in "${or_groups[@]}"; do
        IFS='+' read -r -a and_tags <<< "$group"
        match=1
        for t in "${and_tags[@]}"; do
            [[ -n "${tagset[$t]}" ]] || match=0
        done
        (( match == 1 )) && return 0   # at least one OR group matches
    done

    return 1  # no OR groups matched
}





args=("$@")

# No arguments, show untagged files
if [[ ${#args[@]} -eq 0 ]]; then
    find . -type f | while IFS= read -r file; do
        if ! getfattr --only-values -n user.xdg.tags "$file" &>/dev/null; then
            printf '%s\n' "$file"
        fi
    done

else

  getfattr -R -n user.xdg.tags . 2>/dev/null |
  while IFS= read -r line; do
      case "$line" in
          "# file: "*)
              file="${line#"# file: "}"
              ;;
          "user.xdg.tags="*)
              # Extract the CSV string
              tags="${line#user.xdg.tags=}"
              tags="${tags%\"}"
              tags="${tags#\"}"

              # Test tags against include/exclude
              if matchtag "$tags" "${args[@]}"; then
                  printf '%s\n' "$file"
              fi
              ;;
      esac
  done


fi
