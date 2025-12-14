#!/usr/bin/env bash

# Wallpaper Management Script
# Usage:
#   set_wallpaper.sh              # Set wallpaper from config file
#   set_wallpaper.sh filename.jpg # Set new wallpaper and update config
#   set_wallpaper.sh --random     # Set random wallpaper from ~/Wallpapers

set -e

# Configuration
CONFIG_FILE="$HOME/.config/wallpaper.conf"
WALLPAPER_DIR="$HOME/Wallpapers"
DEFAULT_WALLPAPER="$WALLPAPER_DIR/gruvbox_spac.jpg"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Ensure wallpaper directory exists
ensure_wallpaper_dir() {
    if [[ ! -d "$WALLPAPER_DIR" ]]; then
        log_warn "Wallpaper directory $WALLPAPER_DIR not found, creating..."
        mkdir -p "$WALLPAPER_DIR"
    fi
}

# Read current wallpaper from config
read_wallpaper_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
        echo "${WALLPAPER_PATH:-$DEFAULT_WALLPAPER}"
    else
        log_warn "Config file not found, using default wallpaper"
        echo "$DEFAULT_WALLPAPER"
    fi
}

# Write wallpaper to config
write_wallpaper_config() {
    local wallpaper_path="$1"
    local config_dir
    config_dir="$(dirname "$CONFIG_FILE")"

    # Ensure config directory exists
    mkdir -p "$config_dir"

    # Write to config file
    echo "# Wallpaper Configuration" >"$CONFIG_FILE"
    echo "# Format: WALLPAPER_PATH=~/Wallpapers/filename.jpg" >>"$CONFIG_FILE"
    echo "# The wallpaper script will read this file and apply the specified wallpaper" >>"$CONFIG_FILE"
    echo "" >>"$CONFIG_FILE"
    echo "WALLPAPER_PATH=$wallpaper_path" >>"$CONFIG_FILE"

    log_info "Wallpaper config updated: $wallpaper_path"
}

# Validate wallpaper file exists
validate_wallpaper() {
    local wallpaper_path="$1"

    # Expand ~ to home directory
    wallpaper_path="${wallpaper_path/#\~/$HOME}"

    if [[ ! -f "$wallpaper_path" ]]; then
        log_error "Wallpaper file not found: $wallpaper_path"
        return 1
    fi

    return 0
}

# Apply wallpaper using xwallpaper
apply_wallpaper() {
    local wallpaper_path="$1"

    # Expand ~ to home directory
    wallpaper_path="${wallpaper_path/#\~/$HOME}"

    # Validate file exists
    if ! validate_wallpaper "$wallpaper_path"; then
        return 1
    fi

    # Apply wallpaper
    if xwallpaper --stretch "$wallpaper_path"; then
        log_info "Wallpaper applied successfully: $(basename "$wallpaper_path")"
        return 0
    else
        log_error "Failed to apply wallpaper: $wallpaper_path"
        return 1
    fi
}

# Get random wallpaper from directory
get_random_wallpaper() {
    ensure_wallpaper_dir

    local wallpapers
    wallpapers=("$WALLPAPER_DIR"/*.{jpg,jpeg,png,bmp,webp})

    # Filter to existing files
    local existing_wallpapers=()
    for wallpaper in "${wallpapers[@]}"; do
        if [[ -f "$wallpaper" ]]; then
            existing_wallpapers+=("$wallpaper")
        fi
    done

    if [[ ${#existing_wallpapers[@]} -eq 0 ]]; then
        log_error "No wallpapers found in $WALLPAPER_DIR"
        return 1
    fi

    # Select random wallpaper
    local random_index=$((RANDOM % ${#existing_wallpapers[@]}))
    local selected_wallpaper="${existing_wallpapers[$random_index]}"

    # Convert to ~ format for config
    echo "${selected_wallpaper/#$HOME/\~}"
}

# Show usage
show_usage() {
    echo "Wallpaper Management Script"
    echo ""
    echo "Usage:"
    echo "  $0                    # Set wallpaper from config file"
    echo "  $0 filename.jpg      # Set new wallpaper and update config"
    echo "  $0 --random          # Set random wallpaper from ~/Wallpapers"
    echo "  $0 --list            # List available wallpapers"
    echo "  $0 --help            # Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 gruvbox_spac.jpg  # Set specific wallpaper"
    echo "  $0 ~/Wallpapers/joyboy.png"
    echo "  $0 --random          # Random selection"
}

# List available wallpapers
list_wallpapers() {
    ensure_wallpaper_dir

    log_info "Available wallpapers in $WALLPAPER_DIR:"

    local wallpapers
    wallpapers=("$WALLPAPER_DIR"/*.{jpg,jpeg,png,bmp,webp})

    local found=false
    for wallpaper in "${wallpapers[@]}"; do
        if [[ -f "$wallpaper" ]]; then
            echo "  $(basename "$wallpaper")"
            found=true
        fi
    done

    if [[ "$found" == false ]]; then
        log_warn "No wallpapers found in $WALLPAPER_DIR"
    fi
}

# Main function
main() {
    local wallpaper_path
    local action="from_config"

    # Parse arguments
    case "${1:-}" in
    --help | -h)
        show_usage
        exit 0
        ;;
    --random | -r)
        action="random"
        ;;
    --list | -l)
        list_wallpapers
        exit 0
        ;;
    "")
        # No argument, use config
        action="from_config"
        ;;
    *)
        # Specific wallpaper provided
        wallpaper_path="$1"

        # If no directory specified, assume ~/Wallpapers/
        if [[ "$wallpaper_path" != *"/"* ]]; then
            wallpaper_path="$WALLPAPER_DIR/$wallpaper_path"
        fi

        # Convert to ~ format for consistency
        wallpaper_path="${wallpaper_path/#$HOME/\~}"
        action="specific"
        ;;
    esac

    # Execute action
    case "$action" in
    "from_config")
        wallpaper_path=$(read_wallpaper_config)
        log_info "Setting wallpaper from config: $(basename "$wallpaper_path")"
        ;;
    "random")
        wallpaper_path=$(get_random_wallpaper)
        if [[ $? -ne 0 ]]; then
            exit 1
        fi
        log_info "Random wallpaper selected: $(basename "$wallpaper_path")"
        ;;
    "specific")
        log_info "Setting specific wallpaper: $(basename "$wallpaper_path")"
        ;;
    esac

    # Validate and apply wallpaper
    if validate_wallpaper "$wallpaper_path"; then
        if apply_wallpaper "$wallpaper_path"; then
            # Update config if not reading from it
            if [[ "$action" != "from_config" ]]; then
                write_wallpaper_config "$wallpaper_path"
            fi
            log_info "Wallpaper set successfully!"
        else
            log_error "Failed to set wallpaper"
            exit 1
        fi
    else
        log_error "Invalid wallpaper file: $wallpaper_path"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"
