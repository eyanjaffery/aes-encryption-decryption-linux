Here’s the README.md file written in proper Markdown format for GitHub:

# Backup Tool for FAA ARMT System

A secure and efficient shell script tool for encrypting, compressing, decrypting, and decompressing files with checksum verification. This tool is designed as part of the **Federal Aviation Administration's (FAA) Airport Resource Management Tool (ARMT)** system to handle sensitive backups and ensure data integrity.

---

## Features

- **Encryption and Compression**:
  - Encrypts files using `aescrypt` for AES-256 encryption.
  - Compresses encrypted files into `.zip` format.
  - Generates SHA-256 checksum files for integrity verification.

- **Decryption and Decompression**:
  - Decompresses `.zip` files and decrypts the `.aes` files.
  - Verifies file integrity against previously generated SHA-256 checksum files.

- **Checksum Verification**:
  - Ensures that files have not been tampered with by comparing checksums.

- **Logging**:
  - Tracks script activity with detailed log entries, including start and end times.

- **Cross-Platform Compatibility**:
  - Tested on macOS and Linux (Bash 3.x and newer).

---

## Requirements

### Dependencies

The tool requires the following commands to be installed:

1. `aescrypt` - For file encryption and decryption.
2. `zip` and `unzip` - For compression and decompression.
3. `shasum` or `sha256sum` - For checksum generation and verification.
4. A terminal application (macOS Terminal, iTerm2, etc.).

### System Compatibility

- **macOS**: Works on macOS Catalina and newer.
- **Linux**: Tested on Ubuntu and Debian-based distributions.

---

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/backup-tool.git
cd backup-tool

2. Make the Scripts Executable

chmod +x *.sh

3. Ensure Dependencies Are Installed

macOS:

brew install aescrypt zip unzip coreutils

Debian/Ubuntu:

sudo apt update
sudo apt install aescrypt zip unzip coreutils

Usage

1. Launch the Script

Run the main script in your terminal:

./backup_tool.sh

2. Select an Operation

Choose an operation from the menu:
	1.	Encrypt and Compress a file
	2.	Decompress and Decrypt a file
	3.	Generate SHA-256 checksum for a file
	4.	Exit

3. Follow the Prompts

	•	For encryption, you will need to enter and confirm a password.
	•	For decryption, you will be prompted for the password used during encryption.
	•	For checksum verification, the script will ensure the file matches its checksum.

Folder Structure

backup-tool/
├── backup_tool.sh         # Main script
├── functions.sh           # Contains reusable functions
├── config.sh              # Configuration variables
├── log.sh                 # Logging functionality
├── secure_checksums/      # Directory for storing checksum files
├── README.md              # Documentation
└── LICENSE                # License file

Examples

Encrypt and Compress

	1.	Run the script and select option 1.
	2.	Choose a file to encrypt and compress.
	3.	Enter and confirm the password.
	4.	The encrypted .aes.zip file and its SHA-256 checksum will be generated.

Decrypt and Decompress

	1.	Run the script and select option 2.
	2.	Choose an .aes.zip file.
	3.	The checksum will be verified (if available).
	4.	Enter the password to decrypt the file.

Generate a Checksum

	1.	Run the script and select option 3.
	2.	Choose a file.
	3.	A SHA-256 checksum will be generated and saved in the secure_checksums folder.

Log File

All operations are logged in backup_tool.log. Example log entries:

2024-11-17 14:32:01 - Script initiated by user eyan on eyanMacBookPro
2024-11-17 14:32:15 - Encryption successful for file sensitive_data.backup
2024-11-17 14:33:30 - Checksum verification passed for sensitive_data.backup.aes.zip
2024-11-17 14:35:45 - Script completed by user eyan on eyanMacBookPro

Customization

Change Log File Location

Update LOG_FILE in config.sh to specify a custom location:

LOG_FILE="/path/to/custom_log_file.log"

Change Checksum Storage

Update CHECKSUM_DIR in config.sh to specify a different checksum storage directory:

CHECKSUM_DIR="/path/to/custom_checksum_directory"

Common Issues

zsh: operation not permitted

	•	Ensure the script has execute permissions:

chmod +x ./backup_tool.sh


	•	Grant Full Disk Access to your terminal app (System Preferences → Security & Privacy → Privacy → Full Disk Access).

Checksum File Not Found

	•	Ensure the checksum file exists in the secure_checksums folder with the correct filename format.

aescrypt Not Found

	•	Install aescrypt via your package manager (brew, apt, etc.).

Future Improvements

	•	Add GUI support for better usability.
	•	Implement email notifications on backup completion.
	•	Add SFTP support for secure file transfers.

License

This project is licensed under the MIT License. See the LICENSE file for details.

Contributing

Contributions are welcome! Please follow these steps:
	1.	Fork the repository.
	2.	Create a new branch (git checkout -b feature-name).
	3.	Commit your changes (git commit -am 'Add new feature').
	4.	Push the branch (git push origin feature-name).
	5.	Open a Pull Request.

Contact

For questions or feedback, please reach out to [your email] or create an issue on the GitHub repository.

---

### **What You Need to Update**
1. Replace `https://github.com/yourusername/backup-tool.git` with your actual GitHub repository URL.
2. Replace `[your email]` with your contact email address.
3. Update any placeholder paths or examples as necessary.

This `README.md` is formatted for GitHub and provides a clear explanation of the project, its setup, usage, and features. It should be ready for upload! Let me know if you'd like further adjustments.
