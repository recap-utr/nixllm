{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/x86_64-linux";
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
        cudaSupport = system == "x86_64-linux";
        llamacppAttr =
          if cudaSupport
          then "cuda"
          else "default";
        llama-cpp = inputs.llama-cpp.packages.${system}.${llamacppAttr};
        python = pkgs.python311;
        functionary = python.pkgs.callPackage ./packages/functionary.nix {};
        vllm = python.pkgs.callPackage ./packages/vllm.nix {};
      in {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config = {
            inherit cudaSupport;
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
                ln -s ${functionary.src}/functionary functionary;
                cp ${./scripts/functionary_server.py} server.py;
                exec ${lib.getExe' self'.packages.functionary "python"} server.py "$@"
              '';
            };
          };
          vllm = {
            type = "app";
            program = pkgs.writeShellApplication {
              name = "vllm-app";
              text = ''
                export LD_LIBRARY_PATH=${lib.makeLibraryPath [pkgs.stdenv.cc.cc "/run/opengl-driver"]};
                exec ${lib.getExe' self'.packages.functionary "python"} -m vllm.entrypoints.openai.api_server "$@"
              '';
            };
          };
        };
        packages = {
          ollama = pkgs.callPackage ./packages/ollama.nix {};
          local-ai = pkgs.callPackage ./packages/local-ai.nix {};
          localai = self'.packages.local-ai;
          litellm = pkgs.callPackage ./packages/litellm.nix {};
          functionary = pkgs.python3.withPackages (ps: [functionary]);
          vllm = pkgs.python3.withPackages (ps: [vllm]);
          llama-cpp = pkgs.callPackage ./packages/llama-cpp-python.nix {
            inherit llama-cpp;
          };
          upload = pkgs.writeShellApplication {
            name = "upload";
            text = ''
              exec ${lib.getExe pkgs.rsync} \
                --progress \
                --archive \
                --delete \
                --exclude-from ".gitignore" \
                --exclude ".git" \
                ./ \
                wi2gpu:recap-utr/nixllm
            '';
          };
        };
        devShells.default = pkgs.mkShell {
          packages = with self'.packages; [upload];
        };
      };
    };
}
