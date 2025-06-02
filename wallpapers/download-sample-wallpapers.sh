#!/bin/bash
# Download sample wallpapers for ShadowlyOS
# Uses free images from Unsplash

set -e

echo "Downloading sample wallpapers for ShadowlyOS..."

# Create wallpapers directory if it doesn't exist
mkdir -p .

# Array of free wallpaper URLs (these are from Unsplash and free to use)
wallpapers=(
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1920&h=1080&fit=crop&crop=entropy&q=80"
    "https://images.unsplash.com/photo-1551334787-21e6bd3ab135?w=1920&h=1080&fit=crop&crop=entropy&q=80"
    "https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=1920&h=1080&fit=crop&crop=entropy&q=80"
    "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=1920&h=1080&fit=crop&crop=entropy&q=80"
    "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1920&h=1080&fit=crop&crop=entropy&q=80"
)

filenames=(
    "shadow-mountains.jpg"
    "shadow-abstract.jpg"
    "shadow-space.jpg"
    "shadow-forest.jpg"
    "shadow-desert.jpg"
)

# Download wallpapers
for i in "${!wallpapers[@]}"; do
    url="${wallpapers[$i]}"
    filename="${filenames[$i]}"
    
    echo "Downloading $filename..."
    
    if command -v curl > /dev/null 2>&1; then
        curl -L -o "$filename" "$url"
    elif command -v wget > /dev/null 2>&1; then
        wget -O "$filename" "$url"
    else
        echo "Error: Neither curl nor wget is available. Please install one of them."
        exit 1
    fi
    
    if [ -f "$filename" ]; then
        echo "✓ Downloaded $filename"
    else
        echo "✗ Failed to download $filename"
    fi
done

echo "Sample wallpapers downloaded successfully!"
echo "You can now build ShadowlyOS with these wallpapers included."

