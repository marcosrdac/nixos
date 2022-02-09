{
  description = "System configuration";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@attrs: 
    let 
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          system = prev.system;
          config.allowUnfree = true;
        };
      # another overlay-stable would also make sense think about it
      };
    in {

      # nixosModules = {
      #   #configHost = {
      #   #  #configHost = import ./lib/modules/configHost ;
      #   #};
      #   #test = {
      #   #  test = import ./lib/modules/test ;
      #   #};
      # };
  
      nixosConfigurations = {

        adam = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = attrs;
          modules = [ 
            #({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            ({ ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            ./configuration.nix
          ];
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
