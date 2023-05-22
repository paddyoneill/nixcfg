{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./boot.nix
      ./disks.nix
    ];

  # Network configuration
  networking.hostName = "ganymede";
  networking.useNetworkd = true;

    # Disable DHCP as a default and only enable on specific interfaces
  networking.useDHCP = lib.mkDefault false;
  networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  # Location info
  time.timeZone = "Europe/London";
  location.provider = "geoclue2";

  # Use UK locale as default
  i18n.defaultLocale = "en_GB.UTF-8";

  # Set keymap in console to UK layout
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  # User configuration
  # TODO: Investigate home-manager for managing user packages / config
  users.users.paddy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
  };

  # PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Disable PulseAudio as it conflicts with PipeWire
  hardware.pulseaudio.enable = false;

  # Xserver / Gnome
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11";
}
