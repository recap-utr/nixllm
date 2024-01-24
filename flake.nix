{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/x86_64-linux";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    systems,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import systems;
      perSystem = {
        pkgs,
        lib,
        system,
        self',
        ...
      }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config = {
            cudaSupport = true;
            allowUnfree = true;
          };
        };
        packages = {
          ollama = pkgs.callPackage ./packages/ollama.nix {};
          local-ai = pkgs.callPackage ./packages/local-ai.nix {};
          localai = self'.packages.local-ai;
          litellm = pkgs.callPackage ./packages/litellm.nix {
            ollama = self'.packages.ollama;
          };
        };
        checks = self'.packages;
      };
    };
}
