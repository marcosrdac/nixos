{
  description = "System configuration";


  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: 

    let 
      readModules = d: map (x: d + "/${x}") (
        builtins.attrNames (builtins.readDir d)
      );

      overlays = {
        unstable = final: prev: {
          unstable = import nixpkgs-unstable {
            system = prev.system;
            config.allowUnfree = true;
          };
        };
      };
    in {

      nixosConfigurations = {

        adam = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;
          modules = [
	      ( { ... }: { nixpkgs.overlays = [ overlays.unstable ]; } )
	    ]
            ++ (readModules ./lib/modules)
            ++ [ ./configuration.nix ];
        };

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
