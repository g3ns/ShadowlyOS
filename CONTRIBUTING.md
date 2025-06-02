# Contributing to ShadowlyOS

Thank you for your interest in contributing to ShadowlyOS! We welcome contributions from the community to help make this custom Arch Linux distribution even better.

## How to Contribute

### Reporting Issues

1. **Search existing issues** first to avoid duplicates
2. **Use the issue templates** when available
3. **Provide detailed information** including:
   - Your system specifications
   - Steps to reproduce the issue
   - Expected vs actual behavior
   - Screenshots or logs when applicable

### Code Contributions

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature-name`
3. **Make your changes** following our coding standards
4. **Test thoroughly** on different systems if possible
5. **Commit with clear messages**: Follow conventional commit format
6. **Push to your fork**: `git push origin feature/your-feature-name`
7. **Create a Pull Request** with a detailed description

### Areas Where We Need Help

#### 🪟 Window Manager Integration
- Improving Hyprland + XFCE4 component integration
- Custom window rules and animations
- Multi-monitor support enhancements
- Gesture support

#### 📦 Package Management
- Creating AUR packages for custom applications
- Optimizing package selection
- Dependency management
- Package testing and validation

#### 🎨 Theming and Design
- Custom GTK/Qt themes
- Icon pack creation
- XFCE4 panel customization
- Consistent design language

#### 🛠️ System Tools
- Enhancing the window search functionality
- Wallpaper manager improvements
- System configuration utilities
- Installation scripts

#### 📚 Documentation
- User guides and tutorials
- Developer documentation
- Configuration examples
- Troubleshooting guides

#### 🧪 Testing
- Hardware compatibility testing
- Performance optimization
- Bug reproduction and verification
- Automated testing scripts

## Development Setup

### Prerequisites

```bash
# Install required packages
sudo pacman -S archiso git base-devel

# Clone the repository
git clone https://github.com/g3ns/ShadowlyOS.git
cd ShadowlyOS
```

### Building the ISO

```bash
# Install build dependencies
./scripts/install-deps.sh

# Build the ISO (requires root)
sudo ./build.sh
```

### Testing Changes

1. **Virtual Machine Testing**:
   ```bash
   # Test in QEMU
   qemu-system-x86_64 -cdrom out/shadowlyos-*.iso -m 4G -enable-kvm
   ```

2. **Hardware Testing**:
   ```bash
   # Flash to USB for real hardware testing
   sudo dd if=out/shadowlyos-*.iso of=/dev/sdX bs=4M status=progress
   ```

## Coding Standards

### Shell Scripts
- Use `#!/bin/bash` shebang
- Follow Google Shell Style Guide
- Include error handling with `set -e`
- Add comprehensive comments
- Use meaningful variable names

### Configuration Files
- Use consistent indentation (4 spaces)
- Comment complex configurations
- Follow upstream format conventions
- Test configurations before committing

### Commit Messages

Follow the conventional commit format:

```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding or fixing tests
- `chore`: Maintenance tasks

Examples:
```
feat(hyprland): add multi-monitor workspace support
fix(wallpaper): resolve video wallpaper memory leak
docs(readme): update installation instructions
```

## Pull Request Guidelines

### Before Submitting

- [ ] Test your changes locally
- [ ] Update documentation if needed
- [ ] Add or update tests when applicable
- [ ] Ensure no merge conflicts
- [ ] Follow the coding standards

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Other (please describe)

## Testing
- [ ] Tested on virtual machine
- [ ] Tested on real hardware
- [ ] Tested specific functionality

## Screenshots (if applicable)

## Additional Notes
```

## Release Process

1. **Version Bumping**: Update version in relevant files
2. **Changelog**: Update CHANGELOG.md with new features and fixes
3. **Testing**: Comprehensive testing on multiple systems
4. **Tagging**: Create annotated tags for releases
5. **ISO Building**: Build and test final ISO
6. **Release Notes**: Comprehensive release documentation

## Community Guidelines

### Code of Conduct

- **Be respectful** and inclusive
- **Help others** learn and contribute
- **Give constructive feedback**
- **Focus on the issue**, not the person
- **Assume good intentions**

### Communication

- Use **GitHub Issues** for bug reports and feature requests
- Use **GitHub Discussions** for general questions and ideas
- Keep discussions **on-topic** and **professional**
- **Search before posting** to avoid duplicates

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Project documentation
- Special contributor badges

## Getting Help

If you need help contributing:

1. **Check the documentation** in the `docs/` directory
2. **Search existing issues** and discussions
3. **Ask in GitHub Discussions**
4. **Reach out to maintainers** for complex questions

## License

By contributing to ShadowlyOS, you agree that your contributions will be licensed under the GPL v3 License.

---

Thank you for helping make ShadowlyOS better! 🎉

