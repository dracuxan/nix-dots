#!/usr/bin/env bash

# Monitor Setup Script
# Usage:
#   setup_monitors.sh                    # Auto-detect and setup dual monitors
#   setup_monitors.sh --dry-run          # Show what would be done without executing
#   setup_monitors.sh --left             # Place external monitor on the left (default)
#   setup_monitors.sh --right            # Place external monitor on the right
#   setup_monitors.sh --above            # Place external monitor above
#   setup_monitors.sh --below            # Place external monitor below
#   setup_monitors.sh --help             # Show this help

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

log_debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1"
}

# Configuration
DRY_RUN=false
POSITION="left"
EXTERNAL_OUTPUT=""
INTERNAL_OUTPUT=""

# Common HDMI output names to try
HDMI_OUTPUTS=("HDMI-1-0" "HDMI-1-1" "HDMI-1" "HDMI-2" "HDMI-A-1" "HDMI-A-0")

# Common internal display names to try
INTERNAL_OUTPUTS=("eDP" "eDP-1" "eDP-1-0" "eDP-1-1" "LVDS" "LVDS-1")

# Show usage
show_usage() {
    echo "Monitor Setup Script"
    echo ""
    echo "Usage:"
    echo "  $0                    # Auto-detect and setup dual monitors"
    echo "  $0 --dry-run          # Show what would be done without executing"
    echo "  $0 --left             # Place external monitor on the left (default)"
    echo "  $0 --right            # Place external monitor on the right"
    echo "  $0 --above            # Place external monitor above"
    echo "  $0 --below            # Place external monitor below"
    echo "  $0 --help             # Show this help"
    echo ""
    echo "Examples:"
    echo "  $0                    # Auto-setup with external on left"
    echo "  $0 --right           # Place external monitor on the right"
    echo "  $0 --dry-run --above # Test placing external above"
}

# Get list of connected monitors
get_connected_monitors() {
    xrandr --query | grep " connected" | cut -d" " -f1 | sort
}

# Find the first available output from a list
find_available_output() {
    local -n outputs_list=$1
    local connected_monitors
    readarray -t connected_monitors < <(get_connected_monitors)

    for output in "${outputs_list[@]}"; do
        for connected in "${connected_monitors[@]}"; do
            if [[ "$output" == "$connected" ]]; then
                echo "$output"
                return 0
            fi
        done
    done

    return 1
}

# Detect external and internal monitors
detect_monitors() {
    log_info "Detecting connected monitors..."

    local connected_monitors
    readarray -t connected_monitors < <(get_connected_monitors)

    if [[ ${#connected_monitors[@]} -eq 0 ]]; then
        log_error "No monitors detected!"
        return 1
    fi

    log_debug "Connected monitors: ${connected_monitors[*]}"

    # Find external HDMI monitor
    if EXTERNAL_OUTPUT=$(find_available_output HDMI_OUTPUTS); then
        log_info "Found external monitor: $EXTERNAL_OUTPUT"
    else
        log_warn "No HDMI external monitor found"
        return 1
    fi

    # Find internal laptop display
    if INTERNAL_OUTPUT=$(find_available_output INTERNAL_OUTPUTS); then
        log_info "Found internal display: $INTERNAL_OUTPUT"
    else
        log_warn "No internal laptop display found, using first connected monitor"
        INTERNAL_OUTPUT="${connected_monitors[0]}"
    fi

    # Make sure we have two different monitors
    if [[ "$EXTERNAL_OUTPUT" == "$INTERNAL_OUTPUT" ]]; then
        log_error "External and internal monitors are the same: $EXTERNAL_OUTPUT"
        return 1
    fi

    log_info "Monitor detection complete: External=$EXTERNAL_OUTPUT, Internal=$INTERNAL_OUTPUT"
    return 0
}

# Execute xrandr command (or simulate for dry run)
execute_xrandr() {
    local cmd="xrandr $*"

    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY-RUN] Would execute: $cmd"
        return 0
    else
        log_debug "Executing: $cmd"
        if eval "$cmd"; then
            log_info "Monitor configuration applied successfully"
            return 0
        else
            log_error "Failed to apply monitor configuration"
            return 1
        fi
    fi
}

# Setup monitor arrangement
setup_monitors() {
    log_info "Setting up monitor arrangement: external on the $POSITION of internal"

    # First, configure external monitor
    execute_xrandr --output "$EXTERNAL_OUTPUT" --auto

    # Then configure internal monitor
    execute_xrandr --output "$INTERNAL_OUTPUT" --auto --primary

    # Finally, set the position
    case "$POSITION" in
    "left")
        execute_xrandr --output "$EXTERNAL_OUTPUT" --auto --left-of "$INTERNAL_OUTPUT"
        ;;
    "right")
        execute_xrandr --output "$EXTERNAL_OUTPUT" --auto --right-of "$INTERNAL_OUTPUT"
        ;;
    "above")
        execute_xrandr --output "$EXTERNAL_OUTPUT" --auto --above "$INTERNAL_OUTPUT"
        ;;
    "below")
        execute_xrandr --output "$EXTERNAL_OUTPUT" --auto --below "$INTERNAL_OUTPUT"
        ;;
    *)
        log_error "Invalid position: $POSITION"
        return 1
        ;;
    esac
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
        --dry-run)
            DRY_RUN=true
            log_info "Dry run mode enabled"
            shift
            ;;
        --left)
            POSITION="left"
            shift
            ;;
        --right)
            POSITION="right"
            shift
            ;;
        --above)
            POSITION="above"
            shift
            ;;
        --below)
            POSITION="below"
            shift
            ;;
        --help | -h)
            show_usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
        esac
    done
}

# Main function
main() {
    log_info "Starting monitor setup script"

    # Parse command line arguments
    parse_args "$@"

    # Detect monitors
    if ! detect_monitors; then
        log_warn "Monitor setup failed - this may be normal if no external monitor is connected"
        exit 0
    fi

    # Setup monitor arrangement
    if setup_monitors; then
        if [[ "$DRY_RUN" == false ]]; then
            log_info "Dual monitor setup completed successfully!"
            log_info "External ($EXTERNAL_OUTPUT) positioned $POSITION internal ($INTERNAL_OUTPUT)"
        else
            log_info "Dry run completed - use without --dry-run to apply changes"
        fi
    else
        log_error "Monitor setup failed"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"
