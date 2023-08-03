# nixos-config
nixos-config

##
```bash
➜  ~ nixos-version
22.11.4369.99fe1b87052 (Raccoon)
➜  ~ nix-info -m
- system: `"x86_64-linux"`
- host os: `Linux 6.3.3, NixOS, 22.11 (Raccoon), 22.11.4369.99fe1b87052`
- multi-user?: `yes`
- sandbox: `yes`
- version: `nix-env (Nix) 2.11.1`
- channels(root): `"home-manager-22.11.tar.gz, nixos-22.11, nixos-unstable"`
- nixpkgs: `/nix/var/nix/profiles/per-user/root/channels/nixos`

```
### i3 config
`cp ~/.config/i3/* ~/WebstormProjects/nixos-config/i3`

### NixOS config
`cp /etc/nixos/*  ~/WebstormProjects/nixos-config/`
`cp /etc/nixos/*  ~/WebstormProjects/nixos-config/nixos/`

### Home Manager config ~/.config/nixpkgs/home.nix
`cp ~/.config/nixpkgs/*  ~/WebstormProjects/nixos-config/home/`

### User `.config`
`cp ~/.config/*  ~/WebstormProjects/nixos-config/config/`


### Minimal Startup
`cp /etc/nixos/*  ~/WebstormProjects/nixos-config/nixos/`