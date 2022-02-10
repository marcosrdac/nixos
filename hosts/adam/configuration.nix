{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  hostConfig = {
    enable = true;

    machine = {
      hostName = "adam";
      timeZone = "Brazil/East";
      stateVersion = "21.05";
    };

    boot = {
      loader.portable = {
        enable = true;
        device = "/dev/disk/by-id/ata-KINGSTON_SA400S37960G_0123456789ABCDEF";
        efiSysMountPoint = "/efi";
      };
      useOSProber = false;
      tmpOnTmpfs = false;
    };
    
    packages = {
      useDefault = true;
      extra = with pkgs; [ ];
    };
  };

}
