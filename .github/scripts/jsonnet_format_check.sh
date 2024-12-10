#!/usr/bin/env bash

# Enable error handling
set -eo pipefail

# Try to enable globstar if available
if ((BASH_VERSINFO[0] >= 4)); then
    shopt -s globstar
fi
shopt -s nullglob

error=0

# change to working directory
cd "${1:-.}"

# Use find as a more portable alternative
find . -type f \( -name "*.jsonnet" -o -name "*.libsonnet" \) | while read -r file; do
    error_this_file=0
    printf 'jsonnetfmt --test -- "%s"\n' "${file}"
    jsonnetfmt --test -- "${file}" || { error=1; error_this_file=1; }
    if [[ $error_this_file -eq 1 ]]; then
        jsonnetfmt -i -- "${file}"
        git --no-pager diff --unified=0 --no-ext-diff -- "${file}" | tail -n +5
    fi
done

exit ${error}
