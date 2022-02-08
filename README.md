# NixOS Flake setup

## First instalation

### Acquire flakes

I am not really confident of my first steps, but I know that, as far as NixOS 21.05, I had to install the unstable version of Nix to have access to `flakes` via:

```sh
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
