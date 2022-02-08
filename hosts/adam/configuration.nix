{ config, pkgs, home-manager, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    home-manager.nixosModule
  ];

  # TODO: NETWORKMANAGER

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

  networking.hostName = "adam";
  time.timeZone = "Brazil/East";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "intl";
  services.xserver.xkbOptions = "caps:swapescape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  users.users.marcosrdac = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    firefox qutebrowser
    lf
    wget
    git
    pavucontrol
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  networking.firewall.enable = false;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  system.stateVersion = "21.05";
}

