{ config, pkgs, home-manager, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    home-manager.nixosModule
    #./test
  ];

  # TODO: NETWORKMANAGER

  #test = {
  #  enable = true;
  #};

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

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''experimental-features = nix-command flakes'';
  };

  networking.hostName = "adam";
  time.timeZone = "Brazil/East";

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

  #sound.enable = false;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;
  services.printing.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  networking.firewall.enable = false;
  services.openssh.enable = true;

  system.stateVersion = "21.05";
}
