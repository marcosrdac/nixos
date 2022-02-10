{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  hostConfig = {
    enable = true;
  };
}
