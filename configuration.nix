# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "mianNixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
    # enabled = "fcitx5";
    # fcitx5.enableRimeData= true;
    # fcitx5.addons = with pkgs; [
    #   fcitx5-rime
    #   fcitx5-chinese-addons
    # ];

    # 我现在用 ibus
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      libpinyin
      rime
    ];
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
  nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

  services.meshcentral.enable = true;
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.defaultSession = "gnome";
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";
  networking.firewall.allowedTCPPorts = [ 3389 ];

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mian = {
    isNormalUser = true;
    description = "Mian-PAT";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "google-chrome"
  ];


  nixpkgs.config.permittedInsecurePackages = [
    "xrdp-0.9.9"
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    gnumake
    gcc
    gthumb
    notejot
    lollypop
    gnome.gnome-tweaks
    gnome.dconf-editor
    gnome.gnome-power-manager
    gnome.gnome-sound-recorder
    python2
    python39
    nodejs-18_x
    jetbrains.webstorm
    yarn
    yarn2nix
    adoptopenjdk-bin
    jetbrains.idea-community
    jetbrains.pycharm-community
    vscode
    dbeaver
    mattermost-desktop
    synergy
    # stretchly
    google-chrome
    ibus-theme-tools
    anydesk
    gnome.adwaita-icon-theme
  ] ++ (with gnomeExtensions; [
    appindicator
    system-monitor
    dash-to-dock
    night-theme-switcher
    proxy-switcher
    clipboard-history
    espresso
    ddterm
    customize-ibus
    topicons-plus
  ]);

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
