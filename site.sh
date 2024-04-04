#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
IFS=$'\n\t'

output_file="./css/site.css"

rm -f "${output_file}"

directory="./css/partials"

for file in "$directory"/*; do
  if [ -f "$file" ]; then
    # echo $file
    filename="$(basename "$file")"
    echo "@import url('/css/partials/${filename}');" >> "$output_file"
  fi
done
