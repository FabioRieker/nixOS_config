{inputs, pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "en_US.UTF-8";
  };

  time.timeZone = "America/New_York";

  services = {
    logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "ignore";
    };
    upower = {
      enable = true;
      percentageLow = 15;
      percentageCritical = 5;
    };
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  users.users.elsteto = {
    isNormalUser = true;
    description = "Elseto";
    extraGroups = ["wheel" "video" "audio" "networkmanager" "docker" "libvirtd" "vboxusers"];
    shell = pkgs.zsh;
  };

  users.groups.docker.members = ["elsteto"];
  users.groups.libvirtd.members = ["elsteto"];
  users.groups.vboxusers.members = ["elsteto"];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "24.11";

  specialisation = {
    work = {
      configuration = {
        imports = [
          ../../modules/work/hyprland.nix
        ];
        system.nixos.tags = ["work" "hyprland"];
        environment.sessionVariables.NIXOS_OZONE_WL = "1";
      };
    };
    gaming = {
      configuration = {
        imports = [
          ../../modules/gaming/kde.nix
        ];
        system.nixos.tags = ["gaming" "kde"];
      };
    };
  };
}
