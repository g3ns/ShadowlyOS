#!/bin/bash
# ShadowlyOS Build Script
# Builds a custom Arch Linux ISO with Hyprland and XFCE4 integration

set -e

# Configuration
WORK_DIR="/home/yoshi/shadowlyos-build"
ISO_NAME="shadowlyos"
ISO_LABEL="ShadowlyOS"
ISO_VERSION=$(date +%Y.%m.%d)
OUT_DIR="$(pwd)/out"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root"
fi

# Check dependencies
print_status "Checking build dependencies..."
for cmd in mkarchiso; do
    if ! command -v $cmd &> /dev/null; then
        print_error "$cmd is required but not installed. Please install archiso package."
    fi
done

# Create work directory
print_status "Setting up build environment..."
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
mkdir -p "$OUT_DIR"

# Copy archiso profile
cp -r /usr/share/archiso/configs/releng/* "$WORK_DIR/"

# Customize packages
print_status "Configuring package list..."
cat packages/packages.list >> "$WORK_DIR/packages.x86_64"

# Copy configurations
print_status "Installing configurations..."
mkdir -p "$WORK_DIR/airootfs/etc/skel/.config/hypr"
cp config/hyprland/hyprland.conf "$WORK_DIR/airootfs/etc/skel/.config/hypr/"

# Copy XFCE4 configurations
mkdir -p "$WORK_DIR/airootfs/etc/skel/.config/xfce4"
if [ -d "config/xfce4" ]; then
    cp -r config/xfce4/* "$WORK_DIR/airootfs/etc/skel/.config/xfce4/"
fi

# Copy custom scripts
if [ -d "scripts" ] && [ "$(ls -A scripts/ 2>/dev/null)" ]; then
    print_status "Installing custom scripts..."
    mkdir -p "$WORK_DIR/airootfs/usr/local/bin"
    cp scripts/*.sh "$WORK_DIR/airootfs/usr/local/bin/" 2>/dev/null || true
    chmod +x "$WORK_DIR/airootfs/usr/local/bin/"*.sh 2>/dev/null || true
else
    print_warning "No custom scripts found in scripts/ directory"
fi

# Copy wallpapers
if [ -d "wallpapers" ] && [ "$(ls -A wallpapers/ 2>/dev/null)" ]; then
    print_status "Installing wallpapers..."
    mkdir -p "$WORK_DIR/airootfs/usr/share/shadowlyos/wallpapers"
    cp wallpapers/* "$WORK_DIR/airootfs/usr/share/shadowlyos/wallpapers/" 2>/dev/null || true
else
    print_warning "No wallpapers found in wallpapers/ directory"
fi

# Copy themes
if [ -d "themes" ] && [ "$(ls -A themes/ 2>/dev/null)" ]; then
    print_status "Installing themes..."
    mkdir -p "$WORK_DIR/airootfs/usr/share/themes"
    cp -r themes/* "$WORK_DIR/airootfs/usr/share/themes/" 2>/dev/null || true
else
    print_warning "No themes found in themes/ directory"
fi

# Create custom installer script
print_status "Creating installer script..."
cat > "$WORK_DIR/airootfs/usr/local/bin/shadowlyos-install" << 'EOF'
#!/bin/bash
# ShadowlyOS Installation Script

echo "Welcome to ShadowlyOS Installer!"
echo "This will guide you through installing ShadowlyOS to your system."
echo ""
echo "Please run: archinstall"
echo "And select the ShadowlyOS profile when prompted."

# TODO: Implement custom installer
archinstall
EOF

chmod +x "$WORK_DIR/airootfs/usr/local/bin/shadowlyos-install"

# Customize ISO boot
print_status "Customizing boot configuration..."
sed -i "s/Arch Linux/ShadowlyOS/g" "$WORK_DIR/grub/grub.cfg"
sed -i "s/Arch Linux/ShadowlyOS/g" "$WORK_DIR/syslinux/archiso_sys-linux.cfg"

# Set ISO label
sed -i "s/ARCH_/SHADOWLY_/g" "$WORK_DIR/profiledef.sh"
sed -i "s/iso_label=.*/iso_label=\"$ISO_LABEL\"/" "$WORK_DIR/profiledef.sh"
sed -i "s/iso_name=.*/iso_name=\"$ISO_NAME\"/" "$WORK_DIR/profiledef.sh"
sed -i "s/iso_version=.*/iso_version=\"$ISO_VERSION\"/" "$WORK_DIR/profiledef.sh"

# Create systemd service to start Hyprland on boot for live session
print_status "Configuring live session..."
mkdir -p "$WORK_DIR/airootfs/etc/systemd/system"
cat > "$WORK_DIR/airootfs/etc/systemd/system/shadowlyos-session.service" << 'EOF'
[Unit]
Description=ShadowlyOS Live Session
After=graphical-session.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/Hyprland
Restart=always

[Install]
WantedBy=graphical.target
EOF

# Enable services
mkdir -p "$WORK_DIR/airootfs/etc/systemd/system/multi-user.target.wants"
ln -sf /usr/lib/systemd/system/NetworkManager.service "$WORK_DIR/airootfs/etc/systemd/system/multi-user.target.wants/"

# Build the ISO
print_status "Building ShadowlyOS ISO... This may take a while."
cd "$WORK_DIR"
mkarchiso -v -w work -o "$OUT_DIR" .

print_success "ShadowlyOS ISO built successfully!"
print_status "ISO location: $OUT_DIR/$ISO_NAME-$ISO_VERSION-x86_64.iso"
print_status "You can now flash this ISO to a USB drive or test it in a VM."

# Cleanup
print_status "Cleaning up build files..."
rm -rf "$WORK_DIR"

print_success "Build complete! 🎆"

