#!/bin/sh
set -eu

if [ "$#" -ne 3 ]; then
  echo "usage: prepare-effective-prompt.sh BASE_PROMPT OPTIONAL_JSON EFFECTIVE_PROMPT" >&2
  exit 64
fi

base_prompt=$1
optional_json=$2
effective_prompt=$3

test -f "$base_prompt"
test -f "$optional_json"
jq -e 'type == "object"' "$optional_json" >/dev/null

canonical_file=$(mktemp "${TMPDIR:-/tmp}/prompt-optional.XXXXXX")
trap 'rm -f "$canonical_file"' EXIT HUP INT TERM
jq -cS . "$optional_json" >"$canonical_file"

base_hash=$(shasum -a 256 "$base_prompt" | awk '{print $1}')
optional_hash=$(shasum -a 256 "$canonical_file" | awk '{print $1}')
canonical_value=$(jq -cS . "$optional_json")

if [ "$canonical_value" = "{}" ]; then
  prompt_file=$base_prompt
  prompt_hash=$base_hash
else
  mkdir -p "$(dirname "$effective_prompt")"
  cp "$base_prompt" "$effective_prompt"
  printf '\n\n# Authorized Optional Instructions\n' >>"$effective_prompt"
  sed -n '1p' "$canonical_file" >>"$effective_prompt"
  prompt_file=$effective_prompt
  prompt_hash=$(shasum -a 256 "$effective_prompt" | awk '{print $1}')
fi

jq -n \
  --arg base_prompt_file "$base_prompt" \
  --arg base_prompt_sha256 "$base_hash" \
  --arg prompt_file "$prompt_file" \
  --arg prompt_sha256 "$prompt_hash" \
  --arg optional_instructions_sha256 "$optional_hash" \
  --argjson optional_instructions "$canonical_value" \
  '{
    base_prompt_file: $base_prompt_file,
    base_prompt_sha256: $base_prompt_sha256,
    prompt_file: $prompt_file,
    prompt_sha256: $prompt_sha256,
    optional_instructions: $optional_instructions,
    optional_instructions_sha256: $optional_instructions_sha256
  }'
