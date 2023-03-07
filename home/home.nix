{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mian";
  home.homeDirectory = "/home/mian";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
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
     lock = "i3lock -i '~/lockimgs/lol-1.png'";
   };
   oh-my-zsh = {
     enable = true;
     plugins = [ "git" "dotenv" "kubectl" "history" "docker" ];
     theme = "robbyrussell";
  };
 };
}
