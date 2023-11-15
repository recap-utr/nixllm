{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    llama-cpp = {
      url = "github:ggerganov/llama.cpp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    systems,
    llama-cpp,
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
          ollama = pkgs.callPackage ./ollama.nix {};
          local-ai = pkgs.callPackage ./local-ai.nix {};
          localai = self'.packages.local-ai;
          litellm = pkgs.callPackage ./litellm.nix {};
          llama-cpp = pkgs.callPackage ./llama-cpp-python.nix {
            llama-cpp = llama-cpp.packages.${system}.default;
          };
          llama-cpp-cuda = pkgs.callPackage ./llama-cpp-python.nix {
            llama-cpp = llama-cpp.packages.${system}.cuda;
          };
          llama-cpp-opencl = pkgs.callPackage ./llama-cpp-python.nix {
            llama-cpp = llama-cpp.packages.${system}.opencl;
          };
        };
      };
    };
}
