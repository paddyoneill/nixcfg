{ ... }:

{
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
}
