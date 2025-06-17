#!/bin/bash

# 📋 pat - A handy tool to copy file contents to clipboard 📋
# 🔄 Works with xclip or xsel (whichever is available)
# 🚀 Usage: pat <file>
# 💡 Tip: Add this to your shell config: alias pat='path/to/pat'

# Check if a file was provided
if [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "✨ Usage: $0 <file>"
    echo "📝 Copies file contents to clipboard using xclip or xsel"
    exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
    echo "❌ Error: File '$1' does not exist"
    exit 1
fi

# Function to install xclip
install_xclip() {
    echo "🔍 xclip not found. Would you like to install it? [Y/n]"
    read -r answer
    answer=${answer:-Y}  # Default to Y if empty
    
    if [[ $answer =~ ^[Yy]$ ]]; then
        echo "⚙️  Installing xclip..."
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get update && sudo apt-get install -y xclip
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y xclip
        elif command -v yum >/dev/null 2>&1; then
            sudo yum install -y xclip
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -S --noconfirm xclip
        else
            echo "❌ Could not determine package manager. Please install xclip manually:"
            echo "   https://github.com/astrand/xclip"
            return 1
        fi
        
        if [ $? -eq 0 ]; then
            echo "✅ xclip installed successfully!"
            return 0
        else
            echo "❌ Failed to install xclip. Please install it manually."
            return 1
        fi
    else
        echo "ℹ️  You can install xclip later with: sudo apt install xclip"
        return 1
    fi
}

# Try xclip first
if command -v xclip >/dev/null 2>&1; then
    # Use xclip
    cat "$1" | xclip -selection clipboard
    echo "✅ Copied '$1' to clipboard using xclip"
# Then try xsel if xclip is not available
elif command -v xsel >/dev/null 2>&1; then
    # Use xsel
    cat "$1" | xsel --clipboard --input
    echo "✅ Copied '$1' to clipboard using xsel"
else
    echo "❌ No clipboard tool found!"
    install_xclip && \
        echo "🔄 Retrying with newly installed xclip..." && \
        cat "$1" | xclip -selection clipboard && \
        echo "✅ Successfully copied '$1' to clipboard using xclip" || \
        echo "❌ Please install xclip or xsel and try again"
fi
