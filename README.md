# NixOS Configuration

A complete NixOS flake configuration with specializations for work (Hyprland) and gaming (KDE Plasma).

## Structure

```
.
├── flake.nix              # Main flake entry point
├── shell.nix             # Dev shell for working on config
├── .envrc                # Direnv configuration
├── hosts/
│   └── nixos/
│       ├── default.nix              # Main host config with specializations
│       └── hardware-configuration.nix  # (edit with your disk UUIDs)
├── modules/
│   ├── common.nix        # Shared config (user, packages, etc.)
│   ├── work/
│   │   └── hyprland.nix  # Hyprland + dev tools
│   └── gaming/
│       └── kde.nix       # KDE Plasma + gaming tools
└── home/
    └── elsteto.nix       # Home-manager user config
```

## Installation

### 1. Install NixOS

1. Download the official NixOS ISO from https://nixos.org/download.html
2. Create a bootable USB
3. Install NixOS using the graphical installer
4. During installation, select "Enable NixOS flakes" in the options

### 2. After Installation

1. Clone this repository:
```bash
git clone https://github.com/YOUR_USERNAME/nix-config.git /etc/nixos
cd /etc/nixos
```

2. Edit `hosts/nixos/hardware-configuration.nix` with your actual disk UUIDs:
```bash
sudo blkid  # Find your disk UUIDs
sudo vim hosts/nixos/hardware-configuration.nix
```

3. Build and switch:
```bash
sudo nixos-rebuild switch --flake .#nixos
```

## Specializations

This config uses **NixOS specializations** to switch between work and gaming environments:

### Default (SDDM)
The default configuration boots into SDDM where you can choose between Hyprland or KDE at login.

### Work Specialization
- **Hyprland** - Tiling wayland compositor
- **Waybar** - Status bar with workspaces, audio, network, battery
- **Wofi** - Application launcher
- **Alacritty** - Terminal emulator
- **Dev tools**: vim, git, docker, virt-manager, rust, node, python

To switch to work specialization:
```bash
sudo nixos-rebuild switch --flake .#nixos.work
```

### Gaming Specialization
- **KDE Plasma** - Full desktop environment
- **Steam** - Game launcher
- **Gamemode** - Performance optimization
- **MangoHud** - FPS overlay
- **Lutris/Bottles/Heroic** - Game compatibility layers
- **OBS Studio** - Streaming/recording

To switch to gaming specialization:
```bash
sudo nixos-rebuild switch --flake .#nixos.gaming
```

### Switching at Runtime

You can switch specializations without rebooting:
```bash
# Switch to work
/run/current-system/specialisation/work/bin/switch-to-configuration switch

# Switch to gaming
/run/current-system/specialisation/gaming/bin/switch-to-configuration switch
```

### Switching at Boot

When you rebuild with a specialization, a new boot entry is created. At boot time (in GRUB), you can choose between:
- NixOS Default
- NixOS work
- NixOS gaming

## Customization

### Adding Packages

Add packages to `modules/common.nix` under `environment.systemPackages`.

### Changing Theme Colors

Edit colors in:
- `modules/work/hyprland.nix` - Waybar colors
- `home/elsteto.nix` - Starship prompt

### Changing Time Zone

Edit `hosts/nixos/default.nix`:
```nix
time.timeZone = "America/New_York";  # Change to your timezone
```

## Troubleshooting

### Graphics Issues

If you have issues with graphics drivers, check `modules/gaming/kde.nix`:
```nix
hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
```

Options: `stable`, `beta`, `legacy_390xx`, etc.

### Rebuild Fails

If rebuild fails, check the error and fix the config:
```bash
sudo nixos-rebuild switch --flake .#nixos --show-trace
```

## Credits

Based on [Misterio77/nix-config](https://github.com/Misterio77/nix-config)
