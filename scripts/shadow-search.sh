#!/bin/bash
# Shadow Search - Window and Application Search for ShadowlyOS
# Provides system-wide search functionality similar to macOS Spotlight

# Dependencies: rofi, jq, hyprctl

SCRIPT_NAME="Shadow Search"
CACHE_DIR="$HOME/.cache/shadow-search"
APP_CACHE="$CACHE_DIR/applications.cache"
WINDOW_CACHE="$CACHE_DIR/windows.cache"

# Create cache directory
mkdir -p "$CACHE_DIR"

# Function to update application cache
update_app_cache() {
    {
        # Get desktop applications
        find /usr/share/applications ~/.local/share/applications -name "*.desktop" 2>/dev/null | while read -r desktop_file; do
            if [ -f "$desktop_file" ]; then
                name=$(grep "^Name=" "$desktop_file" | cut -d'=' -f2- | head -n1)
                exec=$(grep "^Exec=" "$desktop_file" | cut -d'=' -f2- | head -n1 | sed 's/ %[fFuU].*$//')
                if [ -n "$name" ] && [ -n "$exec" ]; then
                    echo "APP|$name|$exec"
                fi
            fi
        done
        
        # Add system commands
        echo "APP|Terminal|warp-terminal"
        echo "APP|File Manager|thunar"
        echo "APP|Settings|xfce4-settings-manager"
        echo "APP|Wallpaper Manager|shadow-wallpaper-manager"
        echo "APP|System Monitor|btop"
        echo "APP|Discord|discord"
        echo "APP|VirtualBox|virtualbox"
        echo "APP|Calculator|gnome-calculator"
        echo "APP|Text Editor|nano"
        echo "APP|Web Browser|firefox"
    } > "$APP_CACHE"
}

# Function to get current windows
get_windows() {
    if command -v hyprctl >/dev/null 2>&1; then
        hyprctl clients -j 2>/dev/null | jq -r '.[] | "WINDOW|" + .title + "|" + (.address | tostring)' 2>/dev/null
    fi
}

# Function to search and display results
search() {
    local query="$1"
    
    # Update caches
    update_app_cache
    get_windows > "$WINDOW_CACHE" 2>/dev/null
    
    # Combine and search
    {
        if [ -f "$APP_CACHE" ]; then
            cat "$APP_CACHE"
        fi
        if [ -f "$WINDOW_CACHE" ]; then
            cat "$WINDOW_CACHE"
        fi
        
        # Add quick actions
        echo "ACTION|Lock Screen|loginctl lock-session"
        echo "ACTION|Logout|loginctl terminate-user $USER"
        echo "ACTION|Restart|systemctl reboot"
        echo "ACTION|Shutdown|systemctl poweroff"
        echo "ACTION|Sleep|systemctl suspend"
    } | if [ -n "$query" ]; then
        grep -i "$query"
    else
        cat
    fi
}

# Function to execute selection
execute_selection() {
    local selection="$1"
    local type=$(echo "$selection" | cut -d'|' -f1)
    local name=$(echo "$selection" | cut -d'|' -f2)
    local command=$(echo "$selection" | cut -d'|' -f3)
    
    case "$type" in
        "APP")
            echo "Launching: $name"
            nohup $command >/dev/null 2>&1 &
            ;;
        "WINDOW")
            echo "Focusing window: $name"
            if command -v hyprctl >/dev/null 2>&1; then
                hyprctl dispatch focuswindow "address:$command"
            fi
            ;;
        "ACTION")
            echo "Executing: $name"
            eval "$command"
            ;;
    esac
}

# Main function
main() {
    # Check dependencies
    if ! command -v rofi >/dev/null 2>&1; then
        echo "Error: rofi is required but not installed"
        exit 1
    fi
    
    # Initial cache update
    update_app_cache
    
    # Use rofi for interactive search
    selection=$(search "" | rofi -dmenu -i -p "Search" -format "s" -theme-str 'window {width: 50%; height: 60%;}' -theme-str 'listview {lines: 15;}')
    
    if [ -n "$selection" ]; then
        execute_selection "$selection"
    fi
}

# Daemon mode function
daemon_mode() {
    echo "Shadow Search daemon started"
    
    # Update caches periodically
    while true; do
        update_app_cache
        sleep 30  # Update every 30 seconds
    done
}

# Parse command line arguments
if [ "$1" = "--daemon" ] || [ "$1" = "-d" ]; then
    daemon_mode
    exit 0
fi

# Run main function if script is executed directly
if [ "$(basename "$0")" = "shadow-search.sh" ]; then
    main "$@"
fi

