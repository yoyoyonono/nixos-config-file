# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  swapDevices = [{
    device = "/swapfile";
    size = 8 * 1024; 
  }];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ 
    "i2c-dev" 
    "i2c-piix4" 
  ];
  boot.extraModprobeConfig = ''
    options snd_usb_audio vid=0x1235 pid=0x8212 device_setup=1
  '';
  boot.supportedFilesystems = [ "ntfs" ];

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
    substituters = ["https://aseipp-nix-cache.freetls.fastly.net"];
  };


  networking = {
    hostName = "nixos-yoyo"; # Define your hostname.

    nameservers = [ 
      "1.0.0.1"
      "1.1.1.1" 
      "2606:4700:4700::1001"
      "2606:4700:4700::1111"
    ];


    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    networkmanager = {
      enable = true;
      dns = "none";
    };

    hosts = {
      "192.168.195.225" = ["win-83sjfajhvmg"];
    };

  };


  # Set your time zone.
  time.timeZone = "America/New_York";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk 
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

#  # Enable the GNOME Desktop Environment.
#  services.xserver.displayManager.gdm.enable = true;
#  services.xserver.desktopManager.gnome.enable = true;

  # Enable Plasma for wayland
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    discover
];

#  # Configure keymap in X11
#  services.xserver.xkb = {
#    layout = "us";
#    variant = "";
#  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services = {
    udev.packages = with pkgs; [
      openrgb-with-all-plugins
      platformio-core
      openocd
    ];
  };


  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;

    wireplumber.extraConfig = {
      "d3-fix" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "device.name" = "alsa_card.usb-Audioengine_Audioengine_D3_Audioengine-00";
              }
            ];
            actions = {
              update-props = {
                "api.alsa.ignore-dB" = true;
              };
            };
          }
        ];
      };
    };
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.flatpak = {
    enable = true;
    packages = [
      "io.github.jeffshee.Hidamari"
    ];
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "yoyo";
    dataDir = "/home/yoyo/Documents";
    configDir = "/home/yoyo/.config/syncthing";
  };

  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "b15644912ece0d14" 
    ];
    port = 9993;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yoyo = {
    isNormalUser = true;
    description = "エリナ";
    extraGroups = [ "networkmanager" "wheel" "dialout" "syncthing" "plugdev" "libvirtd"];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs; };
    users = {
      "yoyo" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (texlive.combined.scheme-full.__overrideTeXConfig{withDocs = true;})
    alsa-scarlett-gui
    alsa-utils
    clang
    cmake
    feh
    file
    fuse
    gcc
    gh
    git
    gnumake
    gparted
    htop
    inxi
    kdePackages.kaccounts-integration
    kdePackages.kaccounts-providers
    kdePackages.kio-gdrive
    kdialog
    lf
    lshw
    lutris
    mixxx
    mpv
    neovim
    ntfs3g
    openrgb-with-all-plugins
    platformio
    platformio-core
    powertop
    pulseaudioFull
    rclone
    rustup
    unrar-wrapper
    vim
    virt-manager
    wget
    wineWowPackages.stable
    winetricks
    yakuake
    zoxide
  ];

  fonts = {
    packages = with pkgs; [
      corefonts
      google-fonts 
      ipafont
      kochi-substitute
    ] ++ (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts));
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.zsh = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    systemd
    libGL
    kdePackages.signond
  ];
  
  programs.ns-usbloader = {
    enable = true;
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global.security = "user";
      share = {
        path = "/home/yoyo/Documents";
        "read only" = "yes";
        "guest ok" = "no";
      };
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };

  environment.sessionVariables = {
    EDITOR = "vim";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 
    3389
    445
  ];
  networking.firewall.allowedUDPPorts = [ 
    51820
  ];
  networking.firewall.checkReversePath = false; 
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
