# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos> #mer muss selber de home-manager channel adde
    ];

	# sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
        # sudo nix-channel --update

  # Use the GRUB 2 boot loader.
  #boot.loader.grub.enable = true;
  #boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  boot.loader.systemd-boot.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
   time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "de";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # X Server ohni displaymanager -> nur startx
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.awesome.enable = true;

  services.xserver.wacom.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "de";
  console.useXkbConfig = true;  

  services.xserver.libinput = {
    enable = true;
    touchpad.naturalScrolling = true; 
    touchpad.tapping = true;
  };

  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    #package = pkgs.pulseaudioFull;
    #configFile = pkgs.writeText "default.pa" ''
    #  load-module module-bluetooth-policy
    #  load-module module-bluetooth-discover
      ## module fails to load with 
      ##   module-bluez5-device.c: Failed to get device path from module arguments
      ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
      # load-module module-bluez5-device
      # load-module module-bluez5-discover
    #'';
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;


  #allow unfree software
  nixpkgs.config.allowUnfree = true;

  #hardware.nvidia.modesetting.enable = true;
  services.xserver.videoDrivers = [ "intel" "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  #hardware.nvidia.modesetting.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "vito" ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.vito = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       #BASIC
       firefox
       alacritty
       dolphin
       breeze-qt5
       breeze-icons
       rofi
       libsForQt5.kmix
       networkmanagerapplet
       #xorg.xrdb
       #dex

       #ADVANCED
       vscode
       sublime4
       stremio
       _1password-gui
       spotify
       okular
       mpv
       pcloud
     ];
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    # wget
    git
    gh
    neofetch
   ];

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
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  #vo mir gadded
  security.sudo.extraRules = [
     {
       users = ["vito"];
       commands = [
         {
           command = "ALL";
           options = ["NOPASSWD"];
         }
       ];
     }
  ];

  home-manager.users.vito = { pkgs, ... }: {
    #da köhrt all the home bullshit für de vito user ine
    home.username = "vito";
    home.homeDirectory = "/home/vito";
    home.stateVersion = "22.11";
    programs.home-manager.enable = true;

    home.packages = [
      pkgs.htop
    ];
	
    # xdg.configFile.".config/.keep".source = builtins.toFile "keep" "";
    xdg.configFile."awesome/".source = ./config/awesome;
    xdg.configFile."rofi/".source = ./config/rofi;
    xdg.configFile."alacritty/".source = ./config/alacritty;
    home.file.".xinitrc".source = ./xinitrc;
  };

}

