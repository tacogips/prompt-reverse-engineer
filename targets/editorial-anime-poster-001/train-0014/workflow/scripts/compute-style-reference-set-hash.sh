#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: compute-style-reference-set-hash.sh <records-json> <canonical-json>" >&2
  exit 64
fi

input_path=$1
canonical_path=$2

if [ "$input_path" = "$canonical_path" ]; then
  echo "input and canonical output paths must differ" >&2
  exit 64
fi

jq -ceS '
  if type != "array" or length == 0 then
    error("style reference records must be a non-empty array")
  elif any(.[]; type != "object" or (.path | type) != "string" or (.sha256 | type) != "string" or (.sha256 | test("^[0-9a-f]{64}$") | not)) then
    error("every record must contain path and lowercase SHA-256")
  elif ([.[].path] | unique | length) != length then
    error("style reference paths must be distinct")
  else
    map({path: .path, sha256: .sha256})
  end
' "$input_path" > "$canonical_path"

canonical_sha256=$(shasum -a 256 "$canonical_path" | awk '{print $1}')
canonical_size=$(wc -c < "$canonical_path" | tr -d ' ')

jq -cn \
  --arg canonical_file "$canonical_path" \
  --arg sha256 "$canonical_sha256" \
  --argjson size "$canonical_size" \
  '{canonical_file: $canonical_file, sha256: $sha256, size: $size, serialization: "jq -ceS with final newline"}'
