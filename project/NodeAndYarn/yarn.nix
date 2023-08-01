{ fetchurl, fetchgit, linkFarm, runCommand, gnutar }: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [];
}
