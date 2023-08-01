{ config, pkgs, ...}:
let
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
in {
  environment.systemPackages = with pkgs; [
    #unstable.google-chrome
    #unstable.jetbrains.webstorm
  ];
}
