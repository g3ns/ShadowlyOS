#!/bin/bash
# Shadow Wallpaper Manager - Dynamic wallpaper management for ShadowlyOS
# Supports both static images and video wallpapers (similar to Komorebi)

SCRIPT_NAME="Shadow Wallpaper Manager"
CONFIG_DIR="$HOME/.config/shadow-wallpaper"
WALLPAPER_DIR="$HOME/.local/share/wallpapers"
CURRENT_WALLPAPER="$CONFIG_DIR/current"
VIDEO_WALLPAPER_PID="$CONFIG_DIR/video.pid"

# Create directories
mkdir -p "$CONFIG_DIR" "$WALLPAPER_DIR"

# Default wallpaper directories to search
WALLPAPER_PATHS=(
    "$WALLPAPER_DIR"
    "$HOME/Pictures"
    "/usr/share/shadowlyos/wallpapers"
    "/usr/share/pixmaps"
    "/usr/share/backgrounds"
)

# Supported formats
IMAGE_FORMATS=("jpg" "jpeg" "png" "bmp" "gif" "webp")
VIDEO_FORMATS=("mp4" "mkv" "avi" "mov" "webm")

# Function to stop current video wallpaper
stop_video_wallpaper() {
    if [ -f "$VIDEO_WALLPAPER_PID" ]; then
        local pid=$(cat "$VIDEO_WALLPAPER_PID")
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null
        fi
        rm -f "$VIDEO_WALLPAPER_PID"
    fi
    
    # Kill any remaining mpv instances used for wallpaper
    pkill -f "mpv.*--wid.*wallpaper" 2>/dev/null || true
}

# Function to set image wallpaper
set_image_wallpaper() {
    local image_path="$1"
    
    if [ ! -f "$image_path" ]; then
        echo "Error: Image file not found: $image_path"
        return 1
    fi
    
    echo "Setting image wallpaper: $image_path"
    
    # Stop any video wallpaper
    stop_video_wallpaper
    
    # Set wallpaper using hyprpaper or swaybg
    if command -v hyprpaper >/dev/null 2>&1; then
        # Configure hyprpaper
        cat > "$CONFIG_DIR/hyprpaper.conf" << EOF
preload = $image_path
wallpaper = ,$image_path
EOF
        pkill hyprpaper 2>/dev/null || true
        sleep 0.5
        hyprpaper &
    elif command -v swaybg >/dev/null 2>&1; then
        pkill swaybg 2>/dev/null || true
        swaybg -i "$image_path" &
    else
        echo "Warning: No wallpaper setter found (hyprpaper or swaybg)"
        return 1
    fi
    
    # Save current wallpaper
    echo "IMAGE:$image_path" > "$CURRENT_WALLPAPER"
    return 0
}

# Function to set video wallpaper
set_video_wallpaper() {
    local video_path="$1"
    
    if [ ! -f "$video_path" ]; then
        echo "Error: Video file not found: $video_path"
        return 1
    fi
    
    if ! command -v mpv >/dev/null 2>&1; then
        echo "Error: mpv is required for video wallpapers"
        return 1
    fi
    
    echo "Setting video wallpaper: $video_path"
    
    # Stop current wallpaper
    stop_video_wallpaper
    pkill hyprpaper 2>/dev/null || true
    pkill swaybg 2>/dev/null || true
    
    # Create a script to run the video wallpaper
    cat > "$CONFIG_DIR/video_wallpaper.sh" << EOF
#!/bin/bash
# Video wallpaper player script
while true; do
    mpv --no-audio --loop-file=inf --no-osc --no-input-default-bindings \
        --input-conf=/dev/null --no-osd-bar --profile=low-latency \
        --opengl-hwdec-interop=auto --hwdec=auto --x11-bypass-compositor=yes \
        --geometry=+0+0 --autofit=100%x100% --border=no \
        --ontop --below --no-focus-on-open \
        "$video_path" 2>/dev/null
    sleep 1
done
EOF
    
    chmod +x "$CONFIG_DIR/video_wallpaper.sh"
    
    # Start video wallpaper in background
    nohup "$CONFIG_DIR/video_wallpaper.sh" >/dev/null 2>&1 &
    echo $! > "$VIDEO_WALLPAPER_PID"
    
    # Save current wallpaper
    echo "VIDEO:$video_path" > "$CURRENT_WALLPAPER"
    return 0
}

# Function to find wallpapers
find_wallpapers() {
    local search_query="$1"
    
    for dir in "${WALLPAPER_PATHS[@]}"; do
        if [ -d "$dir" ]; then
            # Find image files
            for ext in "${IMAGE_FORMATS[@]}"; do
                find "$dir" -type f -iname "*.$ext" 2>/dev/null
            done
            
            # Find video files
            for ext in "${VIDEO_FORMATS[@]}"; do
                find "$dir" -type f -iname "*.$ext" 2>/dev/null
            done
        fi
    done | if [ -n "$search_query" ]; then
        grep -i "$search_query"
    else
        cat
    fi | sort
}

# Function to get file type
get_file_type() {
    local file_path="$1"
    local extension="${file_path##*.}"
    extension="${extension,,}" # Convert to lowercase
    
    for fmt in "${IMAGE_FORMATS[@]}"; do
        if [ "$extension" = "$fmt" ]; then
            echo "image"
            return
        fi
    done
    
    for fmt in "${VIDEO_FORMATS[@]}"; do
        if [ "$extension" = "$fmt" ]; then
            echo "video"
            return
        fi
    done
    
    echo "unknown"
}

# Function to show GUI selector
show_gui() {
    if ! command -v zenity >/dev/null 2>&1 && ! command -v rofi >/dev/null 2>&1; then
        echo "Error: zenity or rofi is required for GUI mode"
        return 1
    fi
    
    local wallpapers=()
    while IFS= read -r line; do
        wallpapers+=("$line")
    done < <(find_wallpapers)
    
    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "No wallpapers found in search paths"
        return 1
    fi
    
    local selected
    if command -v rofi >/dev/null 2>&1; then
        selected=$(printf '%s\n' "${wallpapers[@]}" | rofi -dmenu -i -p "Select Wallpaper" -format "s")
    else
        selected=$(zenity --list --title="Select Wallpaper" --column="Path" "${wallpapers[@]}" 2>/dev/null)
    fi
    
    if [ -n "$selected" ]; then
        set_wallpaper "$selected"
    fi
}

# Function to set wallpaper (auto-detect type)
set_wallpaper() {
    local file_path="$1"
    local file_type=$(get_file_type "$file_path")
    
    case "$file_type" in
        "image")
            set_image_wallpaper "$file_path"
            ;;
        "video")
            set_video_wallpaper "$file_path"
            ;;
        *)
            echo "Error: Unsupported file type for: $file_path"
            return 1
            ;;
    esac
}

# Function to restore last wallpaper
restore_wallpaper() {
    if [ -f "$CURRENT_WALLPAPER" ]; then
        local current=$(cat "$CURRENT_WALLPAPER")
        local type="${current%%:*}"
        local path="${current#*:}"
        
        case "$type" in
            "IMAGE")
                set_image_wallpaper "$path"
                ;;
            "VIDEO")
                set_video_wallpaper "$path"
                ;;
        esac
    else
        echo "No previous wallpaper found"
    fi
}

# Function to show help
show_help() {
    cat << EOF
Shadow Wallpaper Manager - Dynamic wallpaper management for ShadowlyOS

Usage: $0 [OPTIONS] [FILE]

Options:
  -h, --help          Show this help message
  -g, --gui           Show graphical wallpaper selector
  -l, --list          List available wallpapers
  -r, --restore       Restore last wallpaper
  -s, --stop          Stop current video wallpaper
  -f, --find QUERY    Find wallpapers matching query

Arguments:
  FILE                Path to image or video file to set as wallpaper

Supported formats:
  Images: ${IMAGE_FORMATS[*]}
  Videos: ${VIDEO_FORMATS[*]}

Examples:
  $0 ~/Pictures/wallpaper.jpg    # Set image wallpaper
  $0 ~/Videos/animated.mp4       # Set video wallpaper
  $0 --gui                       # Show wallpaper selector
  $0 --find nature               # Find wallpapers containing 'nature'
EOF
}

# Main function
main() {
    case "${1:-}" in
        "-h"|"--help")
            show_help
            ;;
        "-g"|"--gui")
            show_gui
            ;;
        "-l"|"--list")
            find_wallpapers
            ;;
        "-r"|"--restore")
            restore_wallpaper
            ;;
        "-s"|"--stop")
            stop_video_wallpaper
            echo "Video wallpaper stopped"
            ;;
        "-f"|"--find")
            if [ -n "${2:-}" ]; then
                find_wallpapers "$2"
            else
                echo "Error: Search query required"
                exit 1
            fi
            ;;
        "")
            show_gui
            ;;
        *)
            if [ -f "$1" ]; then
                set_wallpaper "$1"
            else
                echo "Error: File not found: $1"
                exit 1
            fi
            ;;
    esac
}

# Run main function if script is executed directly
if [ "$(basename "$0")" = "shadow-wallpaper-manager.sh" ]; then
    main "$@"
fi

