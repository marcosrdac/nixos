{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.test;
in {
  options.test = {
    enable = mkEnableOption "test";
  };

  config = mkIf cfg.enable {
    helloWorld = pkgs.writeScriptBin "helloWorld" ''
      echo Hello World
    '';
  };
}
