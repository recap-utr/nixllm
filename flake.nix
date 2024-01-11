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
      }: let
        python = pkgs.python311;
        functionaryPythonPackage = python.pkgs.callPackage ./packages/functionary.nix {};
      in {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config = {
            cudaSupport = true;
            allowUnfree = true;
          };
        };
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
          functionary = {
            type = "app";
            program = pkgs.writeShellApplication {
              name = "functionary-app";
              text = ''
                export LD_LIBRARY_PATH=${lib.makeLibraryPath [pkgs.stdenv.cc.cc "/run/opengl-driver"]};
                cd "$(mktemp -d)";
                ln -s ${functionaryPythonPackage.src}/functionary functionary;
                cp ${./scripts/functionary_server.py} server.py;
                exec ${lib.getExe' self'.packages.functionary "python"} server.py "$@"
              '';
            };
          };
        };
        packages = {
          ollama = pkgs.callPackage ./packages/ollama.nix {};
          local-ai = pkgs.callPackage ./packages/local-ai.nix {};
          localai = self'.packages.local-ai;
          litellm = pkgs.callPackage ./packages/litellm.nix {};
          functionary = pkgs.python3.withPackages (ps: [functionaryPythonPackage]);
        };
        checks = {
          inherit (self'.packages) ollama localai litellm;
        };
      };
    };
}
