#!/bin/bash
# ShadowlyOS Installer
# Simple installation script for ShadowlyOS

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}    ShadowlyOS Installer${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
}

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
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This installer must be run as root"
   exit 1
fi

print_header

print_status "Welcome to ShadowlyOS!"
echo "ShadowlyOS is a modern Arch Linux-based distribution featuring:"
echo "  • Hyprland (Wayland compositor)"
echo "  • XFCE4 integration for familiar desktop experience"
echo "  • Custom shadow-themed applications and scripts"
echo "  • Optimized for performance and aesthetics"
echo

print_warning "This installer will use archinstall with ShadowlyOS presets."
print_warning "Make sure you have backed up your data before proceeding!"
echo

read -p "Do you want to continue? [y/N]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_status "Installation cancelled by user."
    exit 0
fi

print_status "Starting ShadowlyOS installation..."
echo

# Check if archinstall is available
if ! command -v archinstall &> /dev/null; then
    print_error "archinstall is not available. Please run this from a ShadowlyOS live session."
    exit 1
fi

# Launch archinstall
print_status "Launching archinstall..."
print_status "Please configure your installation and select appropriate options."
print_status "The system will be set up with Hyprland and XFCE4 after installation."
echo

archinstall

print_success "Installation completed!"
print_status "After rebooting, you'll be greeted with the ShadowlyOS experience."
print_status "Enjoy your new system! 🌙"

