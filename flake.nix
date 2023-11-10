{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      perSystem = {
        pkgs,
        lib,
        system,
        self',
        ...
      }: {
        packages = {
          ollama = pkgs.callPackage ./ollama.nix {};
          localai = pkgs.callPackage ./localai.nix {};
          litellm = pkgs.callPackage ./litellm.nix {};
        };
      };
    };
}
