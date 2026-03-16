{inputs, pkgs, ...}: {
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      builders = "";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      wget
      curl
      git
      vim
      htop
      neofetch
      fastfetch
      tree
      fd
      ripgrep
      bat
      eza
      fzf
      unzip
      zip
      tar
      gnumake
      gcc
      pkg-config
      python3
      python3Packages.pip
      rustup
      cargo
      nodejs
      bun
      docker-compose
      virt-manager
      dnsmasq
      bridge-utils
      libguestfs
      virtualbox
      virtualboxEXTPack
    ];

    sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
      XDG_CONFIG_HOME = "$HOME/.config";
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "Elseto";
      userEmail = "faabiioo05@gmail.com";
      lfs.enable = true;
    };
    command-not-found = pkgs.command-not-found;
  };

  services = {
    dbus.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    printing.enable = true;
    saned.enable = true;
    virtualbox = {
      enable = true;
      enableExtensionPack = true;
    };
  };

  home-manager.users.elsteto = {pkgs, ...}: {
    imports = [../../home/elsteto.nix];

    home = {
      stateVersion = "24.11";
      sessionVariables = {
        EDITOR = "vim";
      };
    };

    programs = {
      vim = {
        enable = true;
        defaultEditor = true;
        settings = {
          number = true;
          relativenumber = true;
          tabstop = 2;
          shiftwidth = 2;
          expandTab = true;
          cursorline = true;
          signcolumn = "yes";
          backup = false;
          writeBackup = false;
          swapFile = false;
        };
        plugins = with pkgs.vimPlugins; [
          vim-nix
          coc-nvim
        ];
      };
    };
  };

  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-unstable";
    allowReboot = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowedInsecurePackages = [];
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = ["quiet" "loglevel=3"];
    console.font = ["ter-v16n"];
    plymouth.enable = true;
    extraModulePackages = with config.boot.kernelPackages; [
      virtualbox
      virtualboxGuestAdditions
    ];
  };
}
