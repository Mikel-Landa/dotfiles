#!/usr/bin/env bash

set -eo pipefail

# Prompt for work email
echo "Enter work email address:"
read -r WORK_EMAIL

if [[ -z "$WORK_EMAIL" ]]; then
    echo "Error: Work email is required"
    exit 1
fi

# Check if key already exists
if gpg --list-secret-keys --keyid-format LONG "$WORK_EMAIL" &>/dev/null; then
    echo "GPG key for $WORK_EMAIL already exists, using existing key"
    GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format LONG "$WORK_EMAIL" 2>/dev/null | grep -E "^sec" | sed -n 's/.*\/\([A-Z0-9]\{16\}\).*/\1/p' | head -1)
else
    echo "Generating new GPG key for $WORK_EMAIL..."
    # Create temporary key specification file
    KEY_SPEC=$(mktemp)
    cat > "$KEY_SPEC" <<EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: Mikel Landa
Name-Email: $WORK_EMAIL
Expire-Date: 0
%no-protection
EOF

    # Generate the key
    gpg --batch --generate-key "$KEY_SPEC"
    rm "$KEY_SPEC"

    # Extract the key ID
    GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format LONG "$WORK_EMAIL" 2>/dev/null | grep -E "^sec" | sed -n 's/.*\/\([A-Z0-9]\{16\}\).*/\1/p' | head -1)
    
    if [[ -z "$GPG_KEY_ID" ]]; then
        echo "Error: Failed to extract GPG key ID"
        exit 1
    fi
    
    echo "Generated GPG key: $GPG_KEY_ID"
fi

# Write to ~/.gitconfig-work
GITCONFIG_WORK="$HOME/.gitconfig-work"
cat > "$GITCONFIG_WORK" <<EOF
[user]
	email = $WORK_EMAIL
	signingkey = $GPG_KEY_ID
EOF

echo "Updated $GITCONFIG_WORK with email and GPG signing key"