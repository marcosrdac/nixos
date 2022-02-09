{ lib, pkgs, config, inputs, ... }:
with lib;
let cfg = config.default.desktop;
in {

  # imports = [ ../../users/regular.nix ];

  options.default.desktop = {
    enable = mkEnableOption "Enable the default desktop configuration";
  };

  config = mkIf cfg.enable {

    # TODO: NETWORKMANAGER
  
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
      vim
      firefox qutebrowser
      lf
      wget
      git
      pavucontrol
    ];
  
    environment.variables = {
      EDITOR = "vim";
    };
  
    networking.interfaces = {
      enp2s0.useDHCP = false;
      wlp3s0.useDHCP = false;
    };
  
    i18n.defaultLocale = "en_US.UTF-8";

  };
}
