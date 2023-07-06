# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      #./home.nix
      ./unstable.nix
    ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.pathsToLink = [ "/libexec" ];

  networking.hostName = "mianNixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Docker
  virtualisation.docker.enable = true;
  # users.users.mian.extraGroups = ["docker"];
  # Rootless docker
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  
  # VirtualBox
  #virtualisation.virtualbox.host.enable = true;
  #users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  # virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  #virtualisation.virtualbox.guest.enable = true;
  #virtualisation.virtualbox.guest.x11 = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      source-han-sans
      source-han-serif
      # sarasa-gothic  #更纱黑体
      source-code-pro
      hack-font
      jetbrains-mono
      dejavu_fonts
      source-sans-pro
      wqy_microhei
      wqy_zenhei
    ];
  };

   # 简单配置一下 fontconfig 字体顺序，以免 fallback 到不想要的字体
  # fonts.fontconfig = {
     # defaultFonts = {
     #   emoji = [ "Noto Color Emoji" ];
     #   monospace = [
     #     "Noto Sans Mono CJK SC"
     #     "Sarasa Mono SC"
     #     "DejaVu Sans Mono"
     #   ];
     #   sansSerif = [
     #     "Noto Sans CJK SC"
     #     "Source Han Sans SC"
     #     "DejaVu Sans"
     #   ];
     #   serif = [
     #     "Noto Serif CJK SC"
     #     "Source Han Serif SC"
     #     "DejaVu Serif"
     #   ];
     # };
   # };

  fonts.fontconfig.enable = true;

  i18n.inputMethod = {
    enabled = "fcitx5";
    #fcitx5.enableRimeData= true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-chinese-addons
    ];

    
    #enabled = "ibus";
    #ibus.engines = with pkgs.ibus-engines; [
    #  libpinyin
    #  rime
    # ];
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # Nix binary
  nix.settings.substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];

  services.meshcentral.enable = true;
  services.onedrive.enable = true;
  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  #services.xserver.autorun = true;

  services.xserver = {
    enable = true;   
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
      enable = true;
      #package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        #dmenu #application launcher most people use
        rofi
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  };

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.xterm.enable = false;
  #services.xserver.desktopManager.gnome.enable = true;
  #services.xserver.displayManager.defaultSession = "gnome";
  #services.xserver.displayManager.defaultSession = "none+i3";
  #services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";

  #services.xserver.windowManager.i3 = {
  #  enable = true;
  #  package = pkgs.i3-gaps;
  #  extraPackages = with pkgs; [
  #    dmenu #application launcher most people use
  #    i3status # gives you the default i3 status bar
  #    i3lock #default i3 screen locker
  #    i3blocks #if you are planning on using i3blocks over i3status
  # ];
  #};

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 32768;
      to = 65535;
    }
  ];
  networking.firewall.allowedUDPPorts = [
    80
    443
    3389
    6568
    21118
    24800
  ];
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 32768;
      to = 65535;
    }
  ];
  networking.firewall.allowedTCPPorts = [ 
    80
    443
    3389
    21118
    24800    
  ];

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
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
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
#  programs.zsh = {
#    enable = true;
#    shellAliases = {
#      ll = "ls -l";
#      update = "sudo nixos-rebuild switch";
#    };
#  };    
 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  # users.users.yourname.shell = pkgs.zsh;
  users.users.mian = {
    isNormalUser = true;
    description = "Mian-PAT";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  home-manager.users.mian = { pkgs, ... }: {
    home.packages = with pkgs; [
      google-chrome
    ];
    programs.git = {
      enable = true;
      userName  = "mian | mian";
      userEmail = "fangyoy1995+github@gmail.com";
    };
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      sessionVariables = {
        EDITOR = "vim";
      };
      shellAliases = {
        update = "sudo nixos-rebuild switch";
        lock = "i3lock -i '/home/mian/lockimgs/lol-1.png'";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "dotenv" "kubectl" "history" "docker" ];
        theme = "robbyrussell";
      };
    };
    nixpkgs.config.allowUnfree = true;
    home.stateVersion = "22.11";
    #program.home-manager.enable = true;
  };
 
  environment.shells = with pkgs; [ zsh ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    zsh
    oh-my-zsh
    glibc
    gcc12
    home-manager
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    onedrive
    #---- i3
    conky
    i3-gaps
    i3
    i3status
    #dmenu
    rofi
    lxappearance
    #nodejs-18_x
    nodejs-16_x
    google-chrome
    yarn
    yarn2nix
    adoptopenjdk-bin
    mattermost-desktop
    ibus-theme-tools
    anydesk
    netease-cloud-music-gtk
    authy
    enpass
    wpsoffice
    obsidian
    rustdesk
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #  enable = true;
  #  enableSSHSupport = true;
  # };
  # programs.kdeconnect = {
  #  enable = true;
  #  package = pkgs.gnomeExtensions.gsconnect;
  # };
  programs.dconf.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
