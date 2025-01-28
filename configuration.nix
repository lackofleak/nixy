{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking
  networking.hostName = "nixos"; 
  networking.networkmanager.enable = true;
  
  # timezone
  time.timeZone = "Asia/Tehran";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://127.0.0.1:2081";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # internationalisation
  i18n.defaultLocale = "en_US.UTF-8";
  
  # print documents
  services.printing.enable = true;

  # Hyprland 
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    systemd.setPath.enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  # polkit
  security.polkit = {
    enable = true;
    extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions" 
          )
        )
      {
        return polkit.Result.YES;
      }
    });
  '';
  };
  
  # sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };
  services.blueman.enable = true;
  
  # unfree
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE= "1"; 

  # user account
  users.users.amir = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "networkmanager"];
    createHome = true;
    packages = with pkgs; [
    # 1.wm reqired
      dunst
      libsForQt5.qt5.qtwayland
      kitty
      eww
      socat
      jq
      brightnessctl
      playerctl
      wofi
      wl-clipboard
      cliphist
      hyprpolkitagent
      hyprpaper
      hyprshot
      nitch
      pavucontrol
    # 2.daily usage
      google-chrome
      firefox
      tdesktop
      vscode
      obsidian
      mate.atril
      vlc
      amberol
    # 3.thumbnailer
      ffmpegthumbnailer #video
    # 4.archives
      rar
      zip
      unzip
      xarchiver
    ];
  };

  # thunar
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
      exo
    ];
  };
  services.gvfs.enable = true; 
  services.tumbler.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  
  # steam
  programs.steam = {
    enable = true;
    extest.enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true; 
    dedicatedServer.openFirewall = true; 
    localNetworkGameTransfers.openFirewall = true; 
  };


 
  # system pkgs
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    usbutils
  ];


  system.stateVersion = "24.11";

}

