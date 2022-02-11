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

    users = {
      available = {
        marcosrdac = {
          isNormalUser = true;
          extraGroups = [ "wheel" "vboxusers" ];
        };
      };
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

    devices = {
      input = {
        keyboard = {
          ttyLayout = "us";
          xkbLayout = "us";
          xkbVariant = "intl";
          xkbOptions = "caps:swapescape";
        };
      };

      network = {
        interfaces = [ "enp2s0" "wlp3s0" ];
      };
    };

  };

}