{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, nix-flatpak, ... }@inputs:
    let 
      system = "x86_64-linux";
      overlays = [ (import ./overlays)];
      pkgs = import nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "ventoy-1.1.05"
          ];
        };
      };
    in {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
          pkgs = pkgs;
          system = system;
          specialArgs = {inherit inputs;};
          modules = [ 
            ./configuration.nix
            inputs.home-manager.nixosModules.default
            nixos-hardware.nixosModules.asus-zephyrus-ga401
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };
    };
}
