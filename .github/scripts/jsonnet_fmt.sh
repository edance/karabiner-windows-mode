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

# format jsonnet and libsonnet files
for file in ./**/*.{j,lib}sonnet; do
    printf 'jsonnetfmt -i -- "%s"\n' "${file}"
    jsonnetfmt -i -- "${file}" || error=1
done

exit ${error}
