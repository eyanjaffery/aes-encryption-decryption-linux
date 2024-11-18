#!/bin/bash

# Function to check for required commands
check_dependencies() {
    # List of required commands
    required_commands=(aescrypt zip unzip shasum)
    for cmd in "${required_commands[@]}"; do
        # Check if each command is available
        if ! command -v "$cmd" &> /dev/null; then
            echo "Error: $cmd is not installed."
            log "Missing command: $cmd"
            exit 1
        fi
    done
}

# Function to display the script's usage information
show_help() {
    echo "Usage: $0"
    echo
    echo "This script allows you to:"
    echo "1) Encrypt and compress a file"
    echo "2) Decompress and decrypt a file"
    echo "3) Generate SHA-256 checksum for a file"
    echo "4) Exit the script"
    echo
    echo "Follow the on-screen prompts to perform an operation."
    exit 0
}

# Function to prompt for a password securely with confirmation
prompt_password() {
    unset password
    unset password_confirm
    while true; do
        # Prompt for password without echoing input
        read -s -p "Enter password: " password
        echo
        read -s -p "Confirm password: " password_confirm
        echo
        # Check if passwords match
        if [ "$password" == "$password_confirm" ]; then
            break
        else
            echo "Passwords do not match. Please try again."
            echo
        fi
    done
}

# Function to select a file from the current directory
select_file() {
    echo
    echo "Available files in the current directory:"
    echo "-----------------------------------------"

    # Initialize an empty array for storing unique file names
    files=()

    # Populate the array with unique files from all patterns
    for pattern in "*.backup" "*.zip" "*.aes.zip"; do
        for file in $pattern; do
            if [ -e "$file" ] && [[ ! " ${files[*]} " =~ " $file " ]]; then
                files+=("$file")  # Add the file if it is not already in the array
            fi
        done
    done

    # Check if any files were found
    if [ ${#files[@]} -eq 0 ]; then
        echo "No files found with extensions .backup, .zip, or .aes.zip."
        exit 1
    fi

    # Display files with numbering
    for i in "${!files[@]}"; do
        echo "$((i+1))) ${files[i]}"
    done
    echo

    # Prompt user to select a file
    while true; do
        read -p "Enter the number of the file you want to process: " file_index
        if [[ "$file_index" =~ ^[0-9]+$ ]] && [ "$file_index" -ge 1 ] && [ "$file_index" -le "${#files[@]}" ]; then
            selected_file="${files[$((file_index-1))]}"
            echo
            echo "You selected: $selected_file"
            log "Selected file: $selected_file"
            break
        else
            echo "Invalid selection. Please enter a number between 1 and ${#files[@]}."
        fi
    done
}

# Function to generate SHA-256 checksum for a file
create_checksum() {
    checksum_file="$CHECKSUM_DIR/$(basename "$selected_file").sha256"
    echo
    echo "Generating SHA-256 checksum for file: $selected_file"

    # Generate the checksum and include both checksum and filename in the file
    if shasum -a 256 "$selected_file" > "$checksum_file"; then
        echo "Checksum generated successfully and saved to: $checksum_file"
        log "Checksum generated for $selected_file"
    else
        echo "Error: Failed to generate checksum."
        log "Failed to generate checksum for $selected_file"
        exit 1
    fi
    echo
}

# Function to verify SHA-256 checksum
verify_checksum() {
    checksum_file="$CHECKSUM_DIR/$(basename "$compressed_file").sha256"

    # Ensure the checksum file exists
    if [[ ! -f "$checksum_file" ]]; then
        echo "WARNING: CHECKSUM FILE NOT FOUND. INTEGRITY VERIFICATION SKIPPED."
        log "Checksum file not found for $compressed_file"
        return 1
    fi

    # Verify checksum using shasum -a 256 -c
    echo
    echo "Verifying checksum for $compressed_file..."
    if shasum -a 256 -c "$checksum_file" --status; then
        echo "Checksum verification passed: File integrity is intact."
        log "Checksum verification passed for $compressed_file"
        return 0
    else
        echo "Checksum verification failed: File integrity may be compromised."
        log "Checksum verification failed for $compressed_file"
        return 1
    fi
}

# Function to encrypt and compress a file
encrypt_and_compress() {
    prompt_password

    # Encrypt the file
    echo
    echo "Encrypting file: $selected_file"
    if aescrypt -e -p "$password" "$selected_file"; then
        encrypted_file="${selected_file}.aes"
        echo "Encryption successful. Encrypted file created: $encrypted_file"
        log "Encryption successful for $selected_file"
        echo "Removing original file: $selected_file"
        rm "$selected_file"
    else
        echo "Error: Encryption failed."
        log "Encryption failed for $selected_file"
        exit 1
    fi

    # Compress the encrypted file
    compressed_file="${encrypted_file}.zip"
    echo
    echo "Compressing encrypted file: $encrypted_file"
    if zip -q "$compressed_file" "$encrypted_file"; then
        echo "Compression successful. Compressed file created: $compressed_file"
        log "Compression successful for $encrypted_file"
        rm "$encrypted_file"  # Remove the intermediate encrypted file after compression
    else
        echo "Error: Compression failed."
        log "Compression failed for $encrypted_file"
        exit 1
    fi

    # Generate SHA-256 checksum for the compressed file
    selected_file="$compressed_file"
    create_checksum

    # Unset password after use
    unset password
    unset password_confirm

    echo "Operation completed successfully."
    echo
}

# Function to decompress and decrypt a file
decompress_and_decrypt() {
    # Ensure the selected file has a .aes.zip extension
    if [[ "$selected_file" != *.aes.zip ]]; then
        echo "Error: Selected file is not a compressed encrypted file (.aes.zip expected)."
        log "Invalid file selected for decompression: $selected_file"
        exit 1
    fi

    compressed_file="$selected_file"

    # Verify integrity of the compressed file
    if ! verify_checksum; then
        echo "Integrity check failed. Proceeding with caution."
        log "Proceeding without successful integrity check for $compressed_file"
    fi

    # Decompress the file
    echo
    echo "Decompressing file: $compressed_file"
    if unzip -o -q "$compressed_file"; then
        encrypted_file="${compressed_file%.zip}"  # Remove .zip extension
        echo "Decompression successful. Encrypted file extracted: $encrypted_file"
        log "Decompression successful for $compressed_file"
        rm "$compressed_file"  # Remove the compressed file after extraction
    else
        echo "Error: Decompression failed."
        log "Decompression failed for $compressed_file"
        exit 1
    fi

    # Decrypt the file
    prompt_password
    echo
    echo "Decrypting file: $encrypted_file"
    if aescrypt -d -p "$password" "$encrypted_file"; then
        original_file="${encrypted_file%.aes}"  # Remove .aes extension
        echo "Decryption successful. Decrypted file restored: $original_file"
        log "Decryption successful for $encrypted_file"
        rm "$encrypted_file"  # Remove the intermediate encrypted file after decryption
    else
        echo "Error: Decryption failed. Please check your password and try again."
        log "Decryption failed for $encrypted_file"
        exit 1
    fi

    # Unset password after use
    unset password
    unset password_confirm

    echo "Operation completed successfully."
    echo
}

# Function to perform cleanup on script exit
cleanup() {
    unset password
    unset password_confirm
    # Remove any temporary files if necessary
}