{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # this line assume that you also have nixpkgs as an input
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixvim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nix-ld, self, nixpkgs, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default

        # ... add this line to the rest of your configuration modules
        nix-ld.nixosModules.nix-ld

        # nixvim
	inputs.nixvim.nixosModules.nixvim

        # The module in this repository defines a new module under (programs.nix-ld.dev) instead of (programs.nix-ld) 
        # to not collide with the nixpkgs version.
        { programs.nix-ld.dev.enable = true; }
      ];
    };
  };
}
