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
        apps = {
          litellm = {
            type = "app";
            program = pkgs.writeShellApplication {
              name = "litellm-app";
              runtimeInputs = with self'.packages; [ollama];
              text = ''
                exec ${lib.getExe self'.packages.litellm} "$@
              '';
            };
          };
        };
        packages = {
          ollama = pkgs.callPackage ./ollama.nix {};
          localai = pkgs.callPackage ./localai.nix {};
          litellm = pkgs.callPackage ./litellm.nix {};
        };
      };
    };
}
