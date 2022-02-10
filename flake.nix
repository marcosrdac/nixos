{
  description = "System configuration";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: 

    let 

      hostsConfigs = (
        dir: builtins.listToAttrs (
          map (host: {
            name = host;
            value = dir + "/${host}/configuration.nix";
          }) (builtins.attrNames (builtins.readDir dir)))
      ) ./hosts;

      nixosModules = (
        dir: map (mod: dir + "/${mod}")
          (builtins.attrNames (builtins.readDir dir))
      ) ./lib/modules;

      overlay = final: prev: {  # TODO: define these on ./lib/overlays
        unstable = import nixpkgs-unstable {
          system = prev.system;
          config.allowUnfree = true;
        };
      };

      overlayModules = [  # I find this ugly... Investigate it
        ({ ... }: { nixpkgs.overlays = [ overlay ]; })
      ];

      mkHost = hostConfig:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";  # how to get from host?
          specialArgs = inputs;
          modules = overlayModules ++ nixosModules ++ [ hostConfig ];
        };

    in {
      nixosConfigurations = builtins.mapAttrs
        (host: config: mkHost config) hostsConfigs;
    };
}
