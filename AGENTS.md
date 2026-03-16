# AGENTS.md - NixOS Configuration Guide

This document provides guidelines for agents working on this NixOS flake configuration.

## Overview

This is a NixOS flake with specializations for switching between work (Hyprland) and gaming (KDE Plasma) environments. The config uses home-manager for user configuration.

## Hardware Requirements

- **Root filesystem**: Btrfs with `@` subvolume
- **Boot filesystem**: VFAT (EFI)
- **GPU**: NVIDIA (for gaming) / Intel integrated (for work)

## Initial Setup

### 1. Get Disk UUIDs

Run on your target system:
```bash
lsblk -o NAME,UUID,FSTYPE
```

Update `hosts/nixos/hardware-configuration.nix` with the real UUIDs.

### 2. Update Personal Info

Replace these placeholders in the config:
- `elsteto@email.com` → your email in `modules/common.nix` and `home/elsteto.nix`
- `Elseto` → your name in git config

### 3. Test in VM

```bash
# Clone repo in NixOS VM
git clone https://github.com/YOUR_USERNAME/nixos-config.git
cd nixos-config

# Build (use specialization if needed)
sudo nixos-rebuild switch --flake .#nixos        # default (Hyprland)
sudo nixos-rebuild switch --flake .#nixos.gaming # KDE Plasma
```

## Build Commands

### Building the System

```bash
# Build the default configuration
sudo nixos-rebuild switch --flake .#nixos

# Build specific specialization
sudo nixos-rebuild switch --flake .#nixos.work    # Hyprland
sudo nixos-rebuild switch --flake .#nixos.gaming  # KDE Plasma

# Build for testing (dry run)
sudo nixos-rebuild dry-run --flake .#nixos

# Build just the system (don't switch)
sudo nixos-rebuild build --flake .#nixos
```

### Evaluating the Configuration

```bash
# Check configuration without building
nix eval .#nixos.config.system.build.toplevel.drvPath

# Show all defined packages
nix flake show

# Check for configuration errors
nix fmt --check .

# Format the entire flake
nix fmt
```

### Home Manager

```bash
# Build home-manager configuration
home-manager switch --flake .

# Or for specific user
home-manager switch --flake .#elsteto
```

### Nix Commands

```bash
# Update flake inputs
nix flake update

# Clean up old generations
sudo nix-collect-garbage -d

# List all generations
sudo nix-env --list-generations -p /nix/var/nix/profiles/system

# Rollback to previous generation
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
```

## Code Style Guidelines

### General Principles

1. **Use Flakes** - All configurations must use the Nix flakes interface
2. **Modular Organization** - Split into reusable modules under `modules/`
3. **Declarative** - Avoid imperative commands; everything should be declarative
4. **Reproducible** - No random behavior; all inputs should be explicit

### Formatting

1. **Use `alejandra`** for formatting (Nix formatter):
   ```bash
   nix fmt                    # Format all .nix files
   nix fmt -- --check .      # Check without modifying
   ```

2. **Indentation**: Use 2 spaces for indentation

3. **Line Length**: Keep lines under 80 characters when practical

4. **Trailing Commas**: Always use trailing commas in attribute sets and lists

### Imports

1. **Relative paths for local modules**:
   ```nix
   imports = [
     ./hardware-configuration.nix
     ../../modules/common.nix
   ];
   ```

2. **Full paths for flake inputs**:
   ```nix
   imports = [
     inputs.home-manager.nixosModules.home-manager
     inputs.disko.nixosModules.disko
   ];
   ```

### Naming Conventions

1. **Files**: Use `kebab-case.nix` for file names
2. **Modules**: Use descriptive names (e.g., `hyprland.nix`, `kde.nix`)
3. **Host names**: Use lowercase, descriptive names (e.g., `nixos`, `desktop`)
4. **Specializations**: Use lowercase (e.g., `work`, `gaming`)
5. **User variables**: Use camelCase (e.g., `$terminal`, `$menu`)

### Attribute Sets

1. **Use shorthand** when possible:
   ```nix
   # Good
   services = {
     foo.enable = true;
     bar = { enable = true; };
   };

   # Avoid
   services.foo.enable = true;
   services.bar = { enable = true; };
   ```

2. **Trailing commas**:
   ```nix
   # Good
   environment.systemPackages = with pkgs; [
     vim
     git
     curl
   ];

   # Avoid (no trailing comma on last item)
   environment.systemPackages = with pkgs; [
     vim
     git
     curl
   ];
   ```

### Functions

1. **Use `let` for local bindings**:
   ```nix
   {inputs, pkgs, ...}: let
     lib = inputs.nixpkgs.lib;
   in {
     # ...
   };
   ```

2. **Destructure imports**:
   ```nix
   {lib, config, pkgs, ...}: {
     # Use lib, config, pkgs directly
   }
   ```

### Types and Assertions

1. **Use type checks** when appropriate:
   ```nix
   options = {
     enable = lib.mkEnableOption "my option";
   };
   
   config = lib.mkIf config.enable {
     # ...
   };
   ```

2. **Use `mkDefault` for optional values**:
   ```nix
   boot.kernelParams = lib.mkDefault ["quiet"];
   ```

### Error Handling

1. **Prefer Nix's built-in error handling**:
   ```nix
   # Use assert for required conditions
   assert stdenv.isLinux -> false;
   
   # Use mkIf for conditional config
   config = lib.mkIf config.services.foo.enable {
     # ...
   };
   ```

2. **Avoid `|| true`** - Use proper conditionals instead

### Working with Specializations

1. **Define in host's default.nix**:
   ```nix
   specialisation = {
     work = {
       configuration = {
         imports = [../../modules/work/hyprland.nix];
         system.nixos.tags = ["work"];
       };
     };
   };
   ```

2. **Use `inheritParentConfig`** if specialization completely replaces parent:
   ```nix
   gaming = {
     inheritParentConfig = false;
     configuration = { /* completely new config */ };
   };
   ```

### Home Manager

1. **Keep user config in `home/` directory**:
   ```nix
   home-manager.users.elsteto = {pkgs, ...}: {
     # home-manager configuration
   };
   ```

2. **Use `programs.` for CLI tool configuration**

3. **Use `wayland.windowManager.hyprland.settings`** for Hyprland config

### Best Practices

1. **Never hardcode secrets** - Use `sops-nix` or environment variables
2. **Use `lib.mkForce`** sparingly - prefer proper option ordering
3. **Keep hardware-specific config in `hardware-configuration.nix`**
4. **Use `with pkgs;`** sparingly - prefer explicit `pkgs.packageName`
5. **Add comments for complex configurations**
6. **Test changes with `dry-run` before switching**
7. **Auto-upgrade is enabled** in common.nix - system updates automatically from nixos-unstable channel

## File Organization

```
.
├── flake.nix              # Entry point, defines inputs/outputs
├── shell.nix              # Dev shell
├── hosts/
│   └── HOSTNAME/
│       ├── default.nix              # Host config + specializations
│       └── hardware-configuration.nix  # Hardware-specific
├── modules/
│   ├── common.nix         # Shared system config
│   ├── work/
│   │   └── hyprland.nix  # Work specialization
│   └── gaming/
│       └── kde.nix       # Gaming specialization
└── home/
    └── USERNAME.nix      # Home-manager user config
```

## Testing Changes

1. **Quick syntax check**:
   ```bash
   nix fmt --check .
   ```

2. **Dry-run build**:
   ```bash
   sudo nixos-rebuild dry-run --flake .#nixos
   ```

3. **Check specific module**:
   ```bash
   nix-instantiate --parse modules/common.nix
   ```

## Common Issues

1. **"cannot evaluate a thunk"** - Check that all imports are correct
2. **"attribute missing"** - Add the required module import
3. **"option conflicts"** - Use `lib.mkForce` or check for duplicate imports
4. **Build fails on first try** - This is normal; read the error and fix incrementally
5. **NVIDIA not working in gaming** - Check `modules/gaming/kde.nix` has correct drivers
