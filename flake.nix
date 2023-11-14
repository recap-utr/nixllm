{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
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
      }: let
        generated = pkgs.callPackage ./_sources/generated.nix {};
      in {
        apps = {
          litellm = {
            type = "app";
            program = pkgs.writeShellApplication {
              name = "litellm-app";
              runtimeInputs = with self'.packages; [ollama];
              text = ''
                exec ${lib.getExe self'.packages.litellm} "$@"
              '';
            };
          };
        };
        packages = {
          ollama = pkgs.callPackage ./ollama.nix {inherit generated;};
          localai = pkgs.callPackage ./localai.nix {};
          local-ai = self'.packages.localai;
          litellm = pkgs.callPackage ./litellm.nix {inherit generated;};
        };
      };
    };
}
