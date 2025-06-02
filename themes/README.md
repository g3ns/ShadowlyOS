# ShadowlyOS Themes

This directory contains custom themes for ShadowlyOS.

## Theme Structure

Themes should follow the standard GTK/Qt theme structure:

```
theme-name/
├── gtk-2.0/
│   └── gtkrc
├── gtk-3.0/
│   └── gtk.css
├── gtk-4.0/
│   └── gtk.css
├── metacity-1/
│   └── metacity-theme-3.xml
└── index.theme
```

## Adding Themes

1. Place theme directories in this folder
2. The build script will copy them to `/usr/share/themes/`
3. Users can then select them in XFCE4 Settings > Appearance

## Recommended Themes

For a dark, shadow-themed experience, consider:

- Arc-Dark
- Materia-Dark
- Nordic
- Dracula
- Gruvbox-Dark

You can download these from:
- [GTK Themes on GNOME-Look](https://www.gnome-look.org/browse/cat/135/)
- [XFCE Themes](https://www.xfce-look.org/browse/cat/138/)

## Creating Custom Themes

For creating ShadowlyOS-specific themes, use a dark color palette with:
- Primary: #1a1a1a (very dark gray)
- Secondary: #2d2d2d (dark gray)  
- Accent: #33ccff (bright blue)
- Accent 2: #00ff99 (bright green)
- Text: #ffffff (white)
- Text Secondary: #cccccc (light gray)

