{
  description = "System configuration";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, nixpkgs, ... }@attrs: {

    nixosModules = {
      configHost = {
        configHost = import ./lib/modules/configHost ;
      };
    };

    nixosConfigurations."adam" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ];
      # it could be ./adam_configuration.nix
      # in fact, I will code a way to reuse configurations between dektops easily
    };

  };
}

# TIP on reading multiple files
#nixosModules = builtins.listToAttrs (
#map
#  (x: { name = x; value = import (./modules + "/${x}"); })
#  (builtins.attrNames (builtins.readDir ./modules)));
#
#nixosConfigurations = 
#builtins.listToAttrs (map (x:
#  {
#    name = x;
#    value = defineFlakeSystem {
#      imports = [
#	(import (./hosts + "/${x}/configuration.nix") { inherit self; })
#      ];
#    };
#  }) (builtins.attrNames (builtins.readDir ./hosts)));
