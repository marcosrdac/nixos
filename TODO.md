# TODO

## Next

- [ ] Make system configuration default as a module
- [ ] Create users on flake.nix without home-manager
- [ ] Create users on flake.nix with home-manager (if advantages are seen)
- [ ] Create module to create users (configUsers)
- [ ] Use configUsers module to create users listed for the host

## Principles

- NixOS should be easy to install
- Each host should have its own configuration file inside hosts
- Each user should be listed along with its configs inside users
- Each host configuration should list the belonging users for the host
- Almost every config should be modularized in lib/modules so that a computer configuration is always clear
- Personal stuff should not be in this repository
- Each user is responsible for using the system as wished (via personal config repositories and HomeManager or not)
- Each user configures their own WM/GE without having to ask root
- Users are to be able to use xinit from DM (if a DM is really wanted)
- Consider creating nix file for overlays (maybe a module?)

## My personal desires
- Default python env should be easily accessable for data analysis stuff
