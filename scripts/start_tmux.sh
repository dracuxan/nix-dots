#!/usr/bin/env bash

# Parse command line arguments
force_new=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--new)
            force_new=true
            shift
            ;;
        *)
            echo "Unknown option: $1" >&2
            echo "Usage: $0 [-n|--new]" >&2
            exit 1
            ;;
    esac
done

logs() {
    local action=$1
    local session_name=$2
    local log_dir="$HOME/.tmux_logs"
    local log_file="$log_dir/tmux_session.log"
    local time_stamp=$(date "+%Y-%m-%d %H:%M:%S")

    # Create log directory if it doesn't exist
    mkdir -p "$log_dir" || {
        echo "Error: Failed to create log directory '$log_dir'." >&2
        return 1
    }

    # Check if log file is writable
    if ! touch "$log_file" 2>/dev/null; then
        echo "Error: Log file '$log_file' is not writable." >&2
        return 1
    fi

    # Write log entry
    echo "$action -> $session_name: $time_stamp" >>"$log_file"
}

tm() {
    # Check if tmux is installed
    if ! command -v tmux >/dev/null 2>&1; then
        echo "Error: tmux is not installed." >&2
        exit 1
    fi

    # Check for existing sessions
    local existing_sessions
    existing_sessions=$(tmux ls 2>/dev/null)

    # Decide whether to create new session or attach to existing
    if [ "$force_new" = true ] || [ -z "$existing_sessions" ]; then
        # Prompt for session name
        if [ "$force_new" = true ] && [ -n "$existing_sessions" ]; then
            echo -n "Enter a name for a new session: "
        else
            echo -n "No sessions found. Enter a name for a new session: "
        fi
        read -r name
        # Validate input
        if [ -z "$name" ]; then
            echo "Error: Session name cannot be empty." >&2
            exit 1
        fi
        # Log before creating session
        logs "new" "$name"
        # Create new session
        tmux new-session -s "$name" || {
            echo "Error: Failed to create session '$name'." >&2
            exit 1
        }
    else
        # Get the most recent session name
        local session_name
        session_name=$(tmux list-sessions -F '#S' | head -n 1) || {
            echo "Error: Failed to retrieve session name." >&2
            exit 1
        }
        # Log before attaching
        logs "enter" "$session_name"
        # Attach to the most recent session
        tmux attach || {
            echo "Error: Failed to attach to session '$session_name'." >&2
            exit 1
        }
    fi
}

# Call the tm function
tm
