{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    llama-cpp = {
      url = "github:ggerganov/llama.cpp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    systems,
    nixgl,
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
        python = pkgs.python3;
        vllm = python.pkgs.callPackage ./vllm.nix {};
        functionary = python.pkgs.callPackage ./functionary.nix {};
      in {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config = {
            inherit cudaSupport;
            allowUnfree = true;
          };
          overlays = [nixgl.overlay];
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
              # exec ${lib.getExe pkgs.nixgl.auto.nixGLDefault} ${lib.getExe' self'.packages.functionary "python"} server.py "$@"
              text = ''
                export LD_LIBRARY_PATH=${lib.makeLibraryPath [pkgs.stdenv.cc.cc "/run/opengl-driver"]};
                ln -s ${functionary.src}/functionary functionary;
                cp ${./functionary_server.py} server.py;
                exec ${lib.getExe' self'.packages.functionary "python"} server.py "$@"
              '';
            };
          };
        };
        packages = {
          ollama = pkgs.callPackage ./ollama.nix {};
          local-ai = pkgs.callPackage ./local-ai.nix {};
          localai = self'.packages.local-ai;
          litellm = pkgs.callPackage ./litellm.nix {};
          functionary = pkgs.python3.withPackages (ps: [
            functionary
            # vllm
          ]);
          llama-cpp = pkgs.callPackage ./llama-cpp-python.nix {
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
