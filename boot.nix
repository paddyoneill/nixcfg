# Bootloader and kernel configuration
{ config, lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Use latest kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  efi.canTouchEfiVariables = true;
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
