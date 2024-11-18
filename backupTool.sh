#!/bin/bash

set -e
umask 077

# Source configuration and function files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/log.sh"
source "$SCRIPT_DIR/functions.sh"

# Log script initiation
log "Script initiated by user $(whoami) on $(hostname)"

# Trap to handle cleanup on script exit
trap cleanup EXIT

# Check if help is requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
fi

# Check if required commands are installed
check_dependencies

# Main script user interface
echo
echo "======================================================================================"
echo "Federal Aviation Administration’s (FAA) Airport Resource Management Tool (ARMT) system"
echo "---------------------------------BACKUP-ENCRYPT/DECRYPT-TOOL--------------------------"
echo "======================================================================================"
echo

while true; do
    echo "Choose an operation:"
    echo "1) Encrypt and Compress a file"
    echo "2) Decompress and Decrypt a file"
    echo "3) Generate SHA-256 checksum for a file"
    echo "4) Exit"
    echo
    read -p "Enter your choice (1, 2, 3, or 4): " operation
    echo

    case "$operation" in
        1)
            select_file
            encrypt_and_compress
            ;;
        2)
            select_file
            decompress_and_decrypt
            ;;
        3)
            select_file
            create_checksum
            ;;
        4)
            echo "Exiting script..."
            log "Script exited by user."
            echo
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter 1, 2, 3, or 4."
            echo
            ;;
    esac
done