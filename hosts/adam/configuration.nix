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
      locale = "en_US.UTF-8";
      stateVersion = "21.05";
    };

    boot = {
      loader.portable = {
        enable = true;
        device = "/dev/disk/by-id/ata-KINGSTON_SA400S37960G_0123456789ABCDEF";
        efiSysMountPoint = "/efi";
      };
      useOSProber = false;
      tmpOnTmpfs = true;
    };

    devices = {
      network = {
        interfaces = [ "enp2s0" "wlp3s0" ];
      };
    };

    packages = with pkgs; {
      extra = [ ];
    };

    users = {
      available = {
        marcosrdac = {
          isNormalUser = true;
          extraGroups = [ "wheel" "vboxusers" ];
        };
      };
    };


  };

}
