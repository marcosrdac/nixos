# NixOS Flake setup

## First instalation

### Acquire flakes

I am not really confident of my first steps, but I know that, as far as NixOS 21.05, I had to install the unstable version of Nix to have access to `flakes` via:

```sh
nix-channel --update
nix-env -f '<nixpkgs>' -iA nixUnstable
```

### Set system hostname

Set your hostname: `flakes` will use it to setup the correct machine. Example for my `adam` desktop:

```sh
hostname adam
```

### Build system

Then to build the machine for the first time:

```sh
nixos-rebuild switch --flake "/etc/nixos#${HOSTNAME}"
```

## Rebuilding in the future

```sh
nixos-rebuild switch
```

## Principles

- NixOS should be easy to reinstall and be ready to use --- so that I no longer feel attachment for my machines
- Each host should have its own configuration file inside ./hosts
- Each user should be listed along with its configs inside ./users
- Each host configuration should list the belonging users for the host
- Almost every config should be modularized in ./lib/modules so that a computer configuration is always clear
- Personal stuff should not be in this repository
- Each user is responsible for using the system as wished (via personal config repositories and HomeManager or not)
- Each user configures their own WM/GE without having to ask root
- Users are to be able to use xinit from DM (if a DM is really wanted)
- Consider creating nix file for overlays (maybe a module?)

## TODO

- [X] Overlay for unfree software
- [ ] Make system configuration default as a module
- [ ] Create users on flake.nix without home-manager
- [ ] Create users on flake.nix with home-manager (if advantages are seen)
- [ ] Create module to create users (configUsers)
- [ ] Use configUsers module to create users listed for the host

## My personal desires
- [ ] Default python env should be easily accessable for data analysis stuff