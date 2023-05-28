# Bootloader and kernel configuration
{ config, lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  efi.canTouchEfiVariables = true;
  };

  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    cpu.amd.updateMicrocode = lib.mkDefault true;
    video.hidpi.enable = lib.mkDefault true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [pkgs.mesa.drivers];
    };
  };
}
