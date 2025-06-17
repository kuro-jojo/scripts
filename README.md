# Scripts Collection

A collection of useful shell scripts for various tasks. These scripts can be easily installed to your system's PATH for convenient access.

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/kuro-jojo/scripts.git
   cd scripts
   ```

2. Make the installation script executable:
   ```bash
   chmod +x install-scripts.sh
   ```

3. Run the installation script with sudo:
   ```bash
   sudo ./install-scripts.sh
   ```
   This will install all scripts listed in `script_list.txt` to `/usr/local/bin/`.

## Usage

### Available Scripts

- `install-scripts` - Install all scripts to /usr/local/bin
- `fwatch` - File watcher script (available on GitHub: https://github.com/kuro-jojo/file-organizer)
- `pat` - Copy file contents to clipboard using xclip or xsel
- `swap` - Reallocate the swap file
- `toolfinder` - Find and display information about tools

### Custom Script List

To use a custom list of scripts for installation:

```bash
sudo ./install-scripts.sh -f /path/to/custom_script_list.txt
```

## Adding New Scripts

1. Add your script to this directory
    a. Make it executable: `chmod +x script_name`
    b. Add it location to `script_list.txt`
2. Or add it location to `script_list.txt` directly
3. Run the installation script

## License

The scripts in this repository are licensed under the MIT [LICENSE](LICENSE).

## Contributing

Feel free to submit issues and enhancement requests.
