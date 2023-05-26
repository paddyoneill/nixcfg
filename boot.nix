# Bootloader and kernel configuration
{ config, lib, ... }:

{
  boot.initrd.availableKernelModules = [ "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  efi.canTouchEfiVariables = true;
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  ##########################################################
  # Using VM for initial testing / configuration creation. #
  # Remove this when moving to baremetal                   #
  ##########################################################
  virtualisation.hypervGuest.enable = true;
}
