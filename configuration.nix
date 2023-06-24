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
  networking.interfaces.enp68s0.useDHCP = lib.mkDefault true;

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
  users.users.paddy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "libvirtd" "qemu-libvirtd" ];
  };

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.paddy = { pkgs, lib, ... }: {
      home.packages = [
        pkgs.emacs
        pkgs.htop
        pkgs.nerdfonts
      ];

      programs.git = {
        enable = true;
        userName = "Patrick O'Neill";
        userEmail = "paddy.oneill93@gmail.com";
      };

      home.file.".emacs.d/init.el".source = ./user/emacs/init.el;

      dconf.settings = {
        "org/gnome/desktop/input-sources" = {
	  sources = [ (lib.hm.gvariant.mkTuple ["xkb" "gb"]) ];
	  xkb-options = [ "ctrl:nocaps" ];
	};
      };

      home.stateVersion = "22.11";
    };
  };

  # Enable font config. Required for fonts installed using HM
  fonts.fontconfig.enable = lib.mkDefault true;

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
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    enable = true;
    layout = "gb";
    xkbOptions = "ctrl:nocaps";
    xkbVariant = "qwerty,";
    videoDrivers = [ "amdgpu" ];
  };

  # Enable libvirt
  virtualisation.libvirtd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11";
}
