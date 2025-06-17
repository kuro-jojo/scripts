#!/bin/bash

# Script to install user scripts to /usr/local/bin
# Usage: sudo ./install-scripts.sh [-f script_list_file]
#        If no file is specified, uses script_list.txt in the script directory

usage() {
    echo "Usage: sudo $0 [-f script_list_file]"
    echo "  -f, --file FILE  Path to a file containing list of scripts to install"
    echo "                   If not provided, uses script_list.txt in the script directory"
    echo "  -h, --help       Show this help message"
    exit 0
}

# Parse command line arguments
SCRIPT_LIST=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--file)
            if [ -z "$2" ]; then
                echo "Error: No file specified after $1"
                usage
                exit 1
            fi
            SCRIPT_LIST="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Error: Unknown option $1"
            usage
            exit 1
            ;;
    esac
done

# Exit on any error
set -e

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please use sudo."
    usage
    exit 1
fi

# Source directory containing the scripts
SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" &>/dev/null && pwd)"
TARGET_DIR="/usr/local/bin"

# Use provided script list or default to script_list.txt in the script directory
if [ -z "$SCRIPT_LIST" ]; then
    SCRIPT_LIST="${SCRIPT_DIR}/script_list.txt"
    echo "Using default script list: $SCRIPT_LIST"
else
    echo "Using custom script list: $SCRIPT_LIST"
fi

# Check if script list file exists
if [ ! -f "$SCRIPT_LIST" ]; then
    echo "Script list file not found: $SCRIPT_LIST"
    echo "Creating a default script list file..."
    # Find all executable scripts in the directory
    find "$SCRIPT_DIR" -maxdepth 1 -type f \( -name "*.sh" -o -perm -u=x \) ! -name "install-scripts.sh" -exec basename {} \; >"$SCRIPT_LIST"
    echo "Created script list file: $SCRIPT_LIST"
    echo "Please review the file and run this script again."
    exit 0
fi

# Read scripts from the list file
readarray -t SCRIPTS <"$SCRIPT_LIST"

# Make sure target directory exists
mkdir -p "$TARGET_DIR"

# Install each script
for script in "${SCRIPTS[@]}"; do
    # Skip empty lines and comments
    [[ -z "$script" || "$script" == \#* ]] && continue

    # Remove .sh extension if present
    script_name="${script%.sh}"

    # Check for script with or without .sh extension
    if [ -f "$SCRIPT_DIR/$script" ]; then
        script_path="$SCRIPT_DIR/$script"
    elif [ -f "$SCRIPT_DIR/$script_name" ]; then
        script_path="$SCRIPT_DIR/$script_name"
    else
        echo "Warning: Script not found: $script"
        continue
    fi

    # Make the script executable
    chmod +x "$script_path"

    # Copy to target directory without .sh extension
    ln -svf "$script_path" "$TARGET_DIR/$script_name"
    echo "Installed $script as $script_name to $TARGET_DIR/"
done

echo -e "✅ Installation complete. You can now run these commands from anywhere:"
for script in "${SCRIPTS[@]}"; do
    [[ -z "$script" || "$script" == \#* ]] && continue
    script_name="${script%.sh}"
    if [ -f "$TARGET_DIR/$script_name" ]; then
        echo "✅ $script_name"
    fi
done
