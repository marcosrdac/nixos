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

    nixosConfigurations.adam = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      #overlays = {
      #  pkg-sets = (
      #    final: prev: {
      #      unstable = import inputs.unstable { system = final.system; };
      #      trunk = import inputs.trunk { system = final.system; };
      #    }
      #  );

      modules = [
        ./configuration.nix 
      ];




    };
  };
}
