# Bootloader and kernel configuration
{ config, lib, pkgs, ... }:

{
  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
      kernelModules = [ "vfio" "vfio_pci" "vfio_iommu_type1" ];
    };

    extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
    extraModprobeConfig = ''
      options kvmfr static_size_mb=128
    '';

    kernelModules = [ "amdgpu" "kvm-amd" "kvmfr"];
    kernelParams = [ "amd_iommu=on" "vfio-pci.ids=1002:744c,1002:ab30,1002:7446,1002:7444,1102:0012" ];

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    efi.canTouchEfiVariables = true;
    };
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
