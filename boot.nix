# Bootloader and kernel configuration
{ config, lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "vfio" "vfio_pci" "vfio_iommu_type1" ];
  boot.kernelModules = [ "amdgpu" "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "amd_iommu=on" "vfio-pci.ids=1002:744c,1002:ab30,1002:7446,1002:7444" ];

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
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [pkgs.mesa.drivers];
    };
  };
}
