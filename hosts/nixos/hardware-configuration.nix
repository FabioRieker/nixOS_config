{lib, ...}: {
  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "rtc"
  ];

  boot.kernelModules = ["kvm-intel" "kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE_WITH_YOUR_ROOT_UUID";
    fsType = "btrfs";
    options = ["subvol=@"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE_WITH_YOUR_BOOT_UUID";
    fsType = "vfat";
  };

  swapDevices = [];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.video.hidpi.enable = lib.mkDefault true;

  nixpkgs.hostPlatform = "x86_64-linux";
}
