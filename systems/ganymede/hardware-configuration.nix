{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Root device
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/27c09bd8-a10d-4812-8674-e463d4b1144a";
      fsType = "ext4";
    };

  # EFI partition
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7EE5-D35E";
      fsType = "vfat";
    };

  # Disable swap
  swapDevices = [ ];

  # Disable DHCP as a default and only enable on specific interfaces
  networking.useDHCP = lib.mkDefault false;
  networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
 
  ##########################################################
  # Using VM for initial testing / configuration creation. #
  # Remove this when moving to baremetal                   #
  ##########################################################
  virtualisation.hypervGuest.enable = true;
}