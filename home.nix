{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];
  users.users.mian.isNormalUser = true;
  home-manager.useUserPackages = true;
  home-manager.users.mian = { config, pkgs, ...}: {
    /* Here goes your home-manager config, eg home.packages = [ pkgs.foo ]; */
    home.stateVersion = "22.11";
    programs.bash.enable = true;
    home.packages = with pkgs;
    [
      jetbrains.idea-community
      jetbrains.pycharm-community
      python310
      go
      clash
      vscode
      dbeaver
      albert
      copyq
      enpass
      kubectl
      mattermost-desktop
      silver-searcher
      mongodb-compass
      # qtcreator
      synergy
      stretchly
    ];
   # program.home-manager.enable = true;
   # programs.dconf.enable = true;
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ dracula-vim ];
      extraConfig = ''
        syntax on
        set clipboard=unnamedplus
        if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
          let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
          let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        endif
        set termguicolors
        set number
        colorscheme dracula
      '';
    };
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
        os-rebuild = "sudo nixos-rebuild switch";
        lock = "i3lock -i '/home/mian/lockimgs/lol-1.png'";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "dotenv" "kubectl" "history" "docker" ];
        theme = "robbyrussell";
      };
    };
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "enpass"
      "vscode"
      "google-chrome"
      "mongodb-compass"
      "goland"
      "clion" "ruby-mine" "webstorm"
    ];
  };
}
