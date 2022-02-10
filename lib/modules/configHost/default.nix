{ lib, pkgs, config, ... }:

with lib;
let cfg = config.hostConfig;
in {

  options.hostConfig = {
    enable = mkEnableOption "Enable default host configuration";

    host = {
      name = mkOption {
        description = "Host name.";
        type = types.uniq types.str;
      };
      zone = mkOption {
        description = "Host time zone.";
        type = types.uniq types.str;
        default = "Brazil/East";
      };
    };

  };

  config = mkIf cfg.enable {

    nix = {
      package = pkgs.nixUnstable;
      extraOptions = ''experimental-features = nix-command flakes'';
    };

    boot.loader = {
      grub = {
        device = "/dev/disk/by-id/ata-KINGSTON_SA400S37960G_0123456789ABCDEF";
        efiSupport = true;
        efiInstallAsRemovable = true;
        useOSProber = false;
      };
      efi.efiSysMountPoint = "/efi";
    };
    boot.tmpOnTmpfs = false;

    networking.hostName = cfg.host.name;
    time.timeZone = cfg.host.zone;
  
    users.users.marcosrdac = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  
    environment.systemPackages = with pkgs; [
      vim neovim
  
      busybox  # > lspci
  
      firefox qutebrowser
      lf
      wget
      git
      pavucontrol
  
      keepassx2
      unstable.spotify
    ];
  
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
  
    system.stateVersion = "21.05";

  };
}
