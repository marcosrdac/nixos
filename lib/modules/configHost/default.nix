{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.hostConfig;
in {

  options.hostConfig = {
    enable = mkEnableOption "Enable default host configuration";

    machine = {

      hostName = mkOption {
        type = with types; uniq str;
        description = "Host name";
        example = "marcos-desktop";
      };

      timeZone = mkOption {
        type = with types; uniq str;
        description = "Host time zone";
        default = "Brazil/East";
        example = "TODO";
      };

      stateVersion = mkOption {
        type = with types; uniq str;
        description = "NixOS state version";
        default = "21.05";
        example = "21.11";
      };
    };

    boot = {
      loader = {
        portable = {
          enable = mkEnableOption ''
            Cofigure NixOS for a removable drive (compatible with both MBR and EFI loaders)
            TODO describe partition setup required
          '';
          device = mkOption {
            type = with types; uniq str;
            description = ''
              Drive device ID (not to be confused with partition ID) in which to install GRUB. Can be gotten from ls TODO
            '';
            default = null;
            example = "/dev/disk/by-id/ata-KINGSTON_SA400S37960G_0123456789ABCDEF";
          };
          efiSysMountPoint = mkOption {
            description = "Mount point for EFI system";
            type = with types; uniq str;
            default = null;
            example = "/efi";
          };
        };
        
        efi = { };

      };

      useOSProber = mkEnableOption ''
        Wether to search for other operational systems for boot menu or not
      '';
      
      tmpOnTmpfs = mkEnableOption ''
        Wether to mount /tmp on RAM or not
      '';

    };

    packages = {
      useDefault = mkEnableOption ''
        Wether to use default system packages or not
      '';
      extra = mkOption {
        description = "Extra packages";
        type = with types; listOf package ;
        default = [ ];
        example = [ inkscape ];
      };
    };

  };


  config = mkIf cfg.enable {

    networking.hostName = cfg.machine.hostName;
    time.timeZone = cfg.machine.timeZone;
    system.stateVersion = cfg.machine.stateVersion;

    nix = {
      package = pkgs.nixUnstable;
      extraOptions = ''experimental-features = nix-command flakes'';
    };

    boot.loader = let
        loaders = rec {
          portable = {
            grub = {
              device = cfg.boot.loader.portable.device;
              efiSupport = true;
              efiInstallAsRemovable = true;
              useOSProber = cfg.boot.useOSProber;
            };
            efi.efiSysMountPoint = cfg.boot.loader.portable.efiSysMountPoint;
          };
          efi = { };  # TODO make it grubby
          default = efi;
        };
      in (
        if (cfg.boot.loader.portable.enable)
        then loaders.portable
        else loaders.default
      );
    boot.tmpOnTmpfs = cfg.boot.tmpOnTmpfs;
 
 
    environment.systemPackages = with pkgs; let
      defaultPackages = [
        vim neovim
  
        busybox  #=: lspci
  
        firefox qutebrowser
        lf
        wget
        git
        pavucontrol
  
        keepassx2
        unstable.spotify
        gimp
        tdesktop  #=: telegram desktop
      ];
      in 
        (if cfg.packages.useDefault
        then defaultPackages
        else [ ]) ++ cfg.packages.extra;
          
  
    environment.variables = {
      EDITOR = "vim";
    };
  
    networking.interfaces = {
      enp2s0.useDHCP = false;
      wlp3s0.useDHCP = false;
    };
  
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };
  
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
  
    services.xserver.libinput.enable = true;
  
    services.xserver.layout = "us";
    services.xserver.xkbVariant = "intl";
    services.xserver.xkbOptions = "caps:swapescape";
  
    sound.enable = true;
    hardware.pulseaudio.enable = true;
    services.printing.enable = true;
  
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  
    networking.firewall.enable = false;
    services.openssh.enable = true;

    users.users.marcosrdac = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  
  };
}
