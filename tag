#!/bin/bash
set -euo pipefail

# Dump all tags in current directory
dump_tags() {
    declare -A counts=()

    while IFS= read -r line; do
        case "$line" in
            "# file: "*)
                file="${line#"# file: "}"
                ;;
            "user.xdg.tags="*)
                tags="${line#user.xdg.tags=}"
                tags="${tags%\"}"
                tags="${tags#\"}"

                IFS=',' read -r -a arr <<< "$tags"
                for tag in "${arr[@]}"; do
                    tag="${tag#"${tag%%[![:space:]]*}"}"
                    tag="${tag%"${tag##*[![:space:]]}"}"
                    [[ -n "$tag" ]] && counts["$tag"]=$((counts["$tag"]+1))
                done
                ;;
        esac
    done < <(getfattr -R -n user.xdg.tags . 2>/dev/null)

    for t in "${!counts[@]}"; do
        printf "%d\t%s\n" "${counts[$t]}" "$t"
    done | sort -n -r
}


# Compare a tag list search with a possible match
match_tag() {
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

    # Convert CSV -> set
    IFS=',' read -r -a tag_arr <<< "$csv"
    declare -A tagset=()
    for t in "${tag_arr[@]}"; do
        t="${t#"${t%%[![:space:]]*}"}"   # trim left
        t="${t%"${t##*[![:space:]]}"}"   # trim right
        [[ -n "$t" ]] && tagset["$t"]=1
    done

    # Check excludes
    for bad in "${exclude[@]}"; do
        if [[ -v tagset["$bad"] ]]; then
            return 1
        fi
    done

    # If no OR groups -> match everything (not excluded)
    [[ ${#or_groups[@]} -eq 0 ]] && return 0

    # Evaluate OR groups
    for group in "${or_groups[@]}"; do
        IFS='+' read -r -a and_tags <<< "$group"
        match=1
        for t in "${and_tags[@]}"; do
            if ! [[ -v tagset["$t"] ]]; then
                match=0
            fi
        done
        (( match == 1 )) && return 0
    done

    return 1
}


# Search for files that match the tag pattern
do_search() {
    local -a args=("$@")

    # No args -> show untagged files
    if [[ ${#args[@]} -eq 0 ]]; then
        find . -type f | while IFS= read -r file; do
            if ! getfattr --only-values -n user.xdg.tags "$file" &>/dev/null; then
                printf '%s\n' "$file"
            fi
        done
        return
    fi

    (
    getfattr -R -n user.xdg.tags . 2>/dev/null |
    while IFS= read -r line; do
        case "$line" in
            "# file: "*)
                file="${line#"# file: "}"
                ;;
            "user.xdg.tags="*)
                tags="${line#user.xdg.tags=}"
                tags="${tags%\"}"
                tags="${tags#\"}"

                if match_tag "$tags" "${args[@]}"; then
                    printf '%s\n' "$file"
                fi
                ;;
        esac
    done
    ) || true
    return 0
}

slugify_path() {
    local path="$1"
    path="${path#./}"
    path="${path//\//__}"
    echo "$path"
}

# Open gwenview on matching files
do_view() {
    # Prevent set -e from killing us if no matches:
    files="$(do_search "$@")"

    if [ -z "$files" ]; then
        echo "No matches."
        return 0
    fi

    dir="$(mktemp -d -p .)"

    while IFS= read -r f; do
        slug=$(slugify_path "$f")
        ln -rsv "$f" "$dir/$slug"
    done <<< "$files"

    gwenview "$dir/" > /dev/null 2>&1

    [[ "$dir" == *tmp* ]] && rm -rfv "$dir"
}


# Change tags on matching files
do_edit() {
    # arguments before '--' are tags, after are file names
    local -a tagargs=()
    local -a files=()
    local found_sep=0

    for a in "$@"; do
        if [[ "$a" == "--" ]]; then
            found_sep=1
            continue
        fi
        if (( found_sep == 0 )); then
            tagargs+=("$a")
        else
            files+=("$a")
        fi
    done

    if (( ${#files[@]} == 0 )); then
        echo "Error: no files provided."
        exit 1
    fi

    # Separate +add and -remove tags
    local -a addtags=()
    local -a removetags=()

    for t in "${tagargs[@]}"; do
        if [[ "$t" == -* ]]; then
            removetags+=("${t:1}")
        else
            addtags+=("$t")
        fi
    done

    for f in "${files[@]}"; do
        old="$(getfattr --only-values -n user.xdg.tags "$f" 2>/dev/null || echo "")"

        IFS=',' read -r -a arr <<< "$old"
        declare -A set=()
        for t in "${arr[@]}"; do
            t="${t#"${t%%[![:space:]]*}"}"
            t="${t%"${t##*[![:space:]]}"}"
            [[ -n "$t" ]] && set["$t"]=1
        done

        # Apply removals
        for r in "${removetags[@]}"; do
            unset "set[$r]"
        done

        # Apply additions
        for a in "${addtags[@]}"; do
            set["$a"]=1
        done

        # Reconstruct CSV
        new=""
        for k in "${!set[@]}"; do
            if [[ -z "$new" ]]; then new="$k"; else new="$new,$k"; fi
        done

        if [[ -n "$new" ]]; then
            setfattr -n user.xdg.tags -v "$new" "$f"
        else
            setfattr -x user.xdg.tags "$f" 2>/dev/null || true
        fi

        echo "Updated $f -> [$new]"
    done
}


# Begin!
if [[ $# -eq 0 ]]; then
    echo "Usage:"
    echo "  tagger --search TAGS..."
    echo "  tagger --view TAGS..."
    echo "  tagger --dump"
    echo "  tagger --edit addtag -removetag -- file1 file2"
    echo ""
    echo "  TAGS format: one+two three+four -five  (one && two) || (three && four) && !five"
    exit 1
fi

cmd="$1"; shift || true

case "$cmd" in
    --search|-s)
        do_search "$@"
        ;;
    --view|-v)
        do_view "$@"
        ;;
    --dump|-d)
        dump_tags
        ;;
    --edit|-e)
        do_edit "$@"
        ;;
    *)
        echo "Unknown command: $cmd"
        exit 1
        ;;
esac

