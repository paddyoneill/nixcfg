{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./boot.nix
      ./disks.nix
    ];

  # Network configuration
  networking = {
    hostName = "ganymede";
    useNetworkd = true;

    #Create bridge for libvirt
    bridges = {
      br0 = {
        interfaces = [ "enp70s0" ];
      };
    };

    # Disable DHCP as a default and only enable on specific interfaces
    useDHCP = lib.mkDefault false;
    interfaces.enp68s0.useDHCP = lib.mkDefault true;
  };

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
    extraGroups = [ "wheel" "video" "kvm" "libvirtd" "qemu-libvirtd" ];
  };

  # Improve disk usage by optimising nix store and enabling garbage collection
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # System packages
  environment = {
    plasma5.excludePackages = with pkgs.libsForQt5; [
      khelpcenter
      plasma-browser-integration
      print-manager
    ];
    systemPackages = with pkgs; [
      looking-glass-client
    ];
  };

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.paddy = { pkgs, lib, ... }: {
      home.sessionVariables = {
        EDITOR = "emacs";
        VIRSH_DEFAULT_CONNECT_URI = "qemu:///system";
      };

      home.packages = with pkgs; [
        firefox
        htop
        (nerdfonts.override { fonts = [ "Hack" ]; })
        pciutils
        ripgrep
        usbutils
      ];

      programs.emacs = {
        enable = true;
        package = pkgs.emacs;
      };

      programs.git = {
        enable = true;
        userName = "Patrick O'Neill";
        userEmail = "paddy.oneill93@gmail.com";
      };

      home.file.".emacs.d/init.el".source = ./user/emacs/init.el;

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

  # Xserver
  services.xserver = {
    displayManager = {
      defaultSession = "plasmawayland";
      sddm.enable = true;
    };
    desktopManager.plasma5.enable = true;
    enable = true;
    layout = "gb";
    xkbOptions = "ctrl:nocaps";
    xkbVariant = "qwerty,";
    videoDrivers = [ "amdgpu" ];
  };

  services.udev = {
    enable = true;
    extraRules = ''
      SUBSYSTEM=="kvmfr", OWNER="root", GROUP="kvm", MODE="0660"
    '';
  };

  # Enable libvirt
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";

      qemu = {
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };

        # Add /dev/kvmfr0 for to QEMU device acl list for looking glass
        verbatimConfig = ''
          cgroup_device_acl = [
            "/dev/null", "/dev/full", "/dev/zero",
            "/dev/random", "/dev/urandom",
            "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
            "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
            "/dev/net/tun", "/dev/vfio/1",
            "/dev/kvmfr0",
          ]

          namespaces = []
        '';
      };
    };
    spiceUSBRedirection.enable = true;
  };

  services.spice-vdagentd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11";
}
