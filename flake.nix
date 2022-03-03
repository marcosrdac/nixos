{
  description = "System configuration";


  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
  };


  outputs = { self, nixpkgs, nixpkgs-unstable, nur, ... }@inputs: 

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

      unstable-overlay = final: prev: {  # TODO: define these on ./lib/overlays
        unstable = import inputs.nixpkgs-unstable {
          system = prev.system;
          config.allowUnfree = true;
        };
      };
      nur-overlay = nur.overlay;

      overlayModules = [  # I find this ugly... Investigation needed
        ({ ... }: { nixpkgs.overlays = [ unstable-overlay nur-overlay ]; })
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
