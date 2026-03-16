{inputs, pkgs, ...}: {
  services = {
    xserver = {
      videoDrivers = ["nvidia" "intel"];
      displayManager = {
        gdm.enable = false;
        sddm = {
          enable = true;
          wayland.enable = true;
        };
      };
      desktopManager = {
        plasma6.enable = true;
      };
    };
    printing.enable = true;
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = false;
    };
  };

  environment.systemPackages = with pkgs; [
    steam
    gamemode
    mangohud
    protonup-qt
    lutris
    bottles
    heroic
    playit
    discord
    vesktop
    obs-studio
    xbox-cloud-server-selector
    gamescope
    wl-clipboard
    brightnessctl
  ];

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetwork = {
        enable = true;
      };
    };
  };

  home-manager.users.elsteto = {pkgs, ...}: {
    programs = {
      firefox = {
        enable = true;
        settings = {
          "browser.shell.checkDefaultBrowser" = false;
        };
      };
    };

    plasma = {
      enable = true;
      workspace = {
        theme = "breeze-dark";
        colorScheme = "BreezeDark";
      };
      desktop = {
        theme = "breeze-dark";
        icons = "breeze-dark";
        cursors = "breeze-dark";
      };
      windowManager = {
        kwin = {
          enable = true;
          settings = {
            Compositing = {
              Enabled = true;
              OpenGLIsUnsafe = false;
              GLMode = "glx";
              HiddenPreviews = true;
              LowLatency = false;
              ShowFps = false;
              SmoothTransformation = true;
            };
            Windows = {
              BorderlessNormalWindows = true;
              ElectricBorderMode = 2;
              ElectricBorderPushAction = "Maximize";
            };
            KRunner = {
              RunInSingleSession = false;
            };
          };
        };
      };
      panel = {
        defaultPanelPlugin = "org.kde.plasma.panel";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "breeze";
      style = "breeze-dark";
    };

    gtk = {
      enable = true;
      theme = {
        name = "Breeze-Dark";
        package = pkgs.breeze-gtk;
      };
      iconTheme = {
        name = "breeze-dark";
        package = pkgs.breeze-icons;
      };
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = pkgs.intel-media-driver;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  boot = {
    kernelParams = [
      "quiet"
      "loglevel=3"
      "nvidia-drm.modeset=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
  };
}
