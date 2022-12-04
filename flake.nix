{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    impermanence.url = github:nix-community/impermanence;
  };

  outputs = {self, nixpkgs, impermanence, ...}@attrs: {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
      	impermanence.nixosModule
        ./configuration.nix
      ];
    };
  };
}
