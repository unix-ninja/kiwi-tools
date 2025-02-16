#!/bin/bash
# This script will read stdin or parameters passed to the script in the form of:
# SALT|HASH
#    or
# SALT:HASH
# This is super useful for converting gitea pbkdf2_v2 hashes.

function convert_hash() {
	HASH=$(echo "$@" | tr '|' ':')
  echo 'sha256:50000:'$(echo -n $HASH | cut -d: -f1 | xxd -r -p | base64)':'$(echo -n $HASH | cut -d: -f2 | xxd -r -p | base64)
}

echo '[+] Run the output hashes through hashcat mode 10900 (PBKDF2-HMAC-SHA256)'
echo

# Check if any arguments were passed to the script
if [ $# -gt 0 ]; then
  # Loop through the arguments
  for HASH in "$@"; do
    convert_hash "$HASH"
  done
else
  # Read from stdin line by line
  while IFS= read -r HASH; do
    convert_hash "$HASH"
  done
fi
