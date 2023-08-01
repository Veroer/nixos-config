with (import <nixpkgs> {});
rec {
  muellshack = mkYarnPackage {
    name = "bigfront";
    src = ./.;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
  };
}
