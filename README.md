# ShadowlyOS

🌟 A custom Arch Linux distribution featuring Hyprland window manager with XFCE4 components integration

## Overview

ShadowlyOS is a carefully crafted Arch Linux-based operating system that combines the power and flexibility of Hyprland with the familiarity and functionality of XFCE4 components. It comes pre-configured with essential applications and modern desktop features.

## Features

### 🪟 Window Manager
- **Hyprland**: Modern Wayland compositor with advanced tiling capabilities
- **XFCE4 Integration**: Seamlessly integrated XFCE4 components for enhanced functionality
- **Window Search Bar**: Quick application and window finder
- **Dynamic Workspaces**: Intelligent workspace management

### 📱 Pre-installed Applications
- **Warp Terminal**: Modern, AI-powered terminal
- **Discord**: Communication platform
- **VirtualBox**: Virtualization software
- **Cave**: Package manager and software center
- **Komorebi-like Wallpaper Manager**: Dynamic background manager supporting images and videos

### 🎨 Desktop Environment
- Custom themed XFCE4 components
- Integrated system tray and panels
- Modern notification system
- Advanced wallpaper management with video support
- System-wide search functionality

## Installation

### Prerequisites
- x86_64 architecture
- 4GB RAM minimum (8GB recommended)
- 20GB free disk space
- UEFI-capable system

### Quick Install
```bash
# Download the latest ISO
wget https://github.com/g3ns/ShadowlyOS/releases/latest/download/shadowlyos.iso

# Create bootable USB (replace /dev/sdX with your USB device)
sudo dd if=shadowlyos.iso of=/dev/sdX bs=4M status=progress

# Boot from USB and follow the installer
```

### Manual Build
```bash
git clone https://github.com/g3ns/ShadowlyOS.git
cd ShadowlyOS
sudo ./build.sh
```

## Configuration

### Hyprland Configuration
The Hyprland configuration is located in `config/hyprland/hyprland.conf` and includes:
- Custom keybindings optimized for productivity
- XFCE4 component integration
- Window rules and animations
- Multi-monitor support

### XFCE4 Components
- **xfce4-panel**: Customized bottom panel
- **xfce4-settings**: System configuration tools
- **thunar**: File manager with enhanced features
- **xfce4-notifyd**: Notification daemon

## Development

### Project Structure
```
ShadowlyOS/
├── build/              # Build scripts and tools
├── config/             # Configuration files
│   ├── hyprland/       # Hyprland configs
│   ├── xfce4/          # XFCE4 component configs
│   └── applications/   # Application configs
├── packages/           # Custom package definitions
├── scripts/            # System scripts and utilities
├── themes/             # Custom themes and styling
├── wallpapers/         # Default wallpaper collection
└── installer/          # Installation scripts
```

### Building from Source
1. Clone the repository
2. Install build dependencies: `./scripts/install-deps.sh`
3. Build the ISO: `sudo ./build.sh`
4. Test in VM or flash to USB

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Areas for Contribution
- Window manager enhancements
- Application packaging
- Theme development
- Documentation improvements
- Bug fixes and optimizations

## Roadmap

- [ ] Complete Hyprland + XFCE4 integration
- [ ] Implement window search functionality
- [ ] Develop wallpaper management system
- [ ] Create custom installer
- [ ] Package pre-installed applications
- [ ] Optimize performance and resource usage
- [ ] Multi-language support

## Screenshots

*Coming soon - screenshots of the desktop environment*

## License

ShadowlyOS is released under the GPL v3 License. See [LICENSE](LICENSE) for details.

## Support

- 📖 [Documentation](https://github.com/g3ns/ShadowlyOS/wiki)
- 🐛 [Issue Tracker](https://github.com/g3ns/ShadowlyOS/issues)
- 💬 [Discussions](https://github.com/g3ns/ShadowlyOS/discussions)

## Acknowledgments

- Arch Linux community
- Hyprland developers
- XFCE team
- All application developers

---

*Built with ❤️ for the Linux community*

