{ config, pkgs, ... }:

{
  users.users.marcosrdac = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "audio" "networkmanager" "lp" "scanner" ];
    openssh.authorizedKeys.keys = [ ];
  };
}

#users.defaultUserShell = pkgs.zsh;
#
#nix.allowedUsers = [ "marcosrdac" ];  # why not * ?
#users.extraGroups = {
#   vboxusers.members = [ "marcosrdac" ];
#};
