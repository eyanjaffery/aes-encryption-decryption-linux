#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Secure directory for storing checksums within the same directory as the script
CHECKSUM_DIR="$SCRIPT_DIR/secure_checksums"

# Create the secure directory with restricted permissions if it doesn't exist
mkdir -p "$CHECKSUM_DIR"
chmod 700 "$CHECKSUM_DIR"  # Restrict permissions to owner only

# Log file for audit trails
LOG_FILE="$SCRIPT_DIR/backup_tool.log"
touch "$LOG_FILE"
chmod 600 "$LOG_FILE"  # Only readable by the owner