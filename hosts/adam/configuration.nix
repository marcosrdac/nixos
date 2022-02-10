{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  hostConfig = {
    enable = true;
    host = {
      name = "adam";
      zone = "Brazil/East";
    };
  };
}
