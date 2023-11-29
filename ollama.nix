{
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
}: let
  inherit (stdenv.hostPlatform) system;
  pname = "ollama";
  version = "0.1.12";
  repo = "https://github.com/jmorganca/ollama";
  srcs = rec {
    x86_64-linux = {
      url = "${repo}/releases/download/v${version}/${pname}-linux-amd64";
      hash = "sha256-qJDWbDdiGu1THcd5X6YrKsG4vrzOh/VsXO81sCajrQ8=";
    };
    aarch64-linux = {
      url = "${repo}/releases/download/v${version}/${pname}-linux-arm64";
      hash = "sha256-g0eydRJZQdjR8+hf0migeMoNQg+syLqPsQBGUdZ5UoQ=";
    };
    x86_64-darwin = {
      url = "${repo}/releases/download/v${version}/${pname}-darwin";
      hash = "sha256-JjOznbRgnzpH3i+ElFTuJFlzpaw7LnJyIe+Gt2AoZeI=";
    };
    aarch64-darwin = x86_64-darwin;
  };
in
  stdenv.mkDerivation {
    inherit pname version;

    passthru = {
      inherit srcs;
    };

    src = fetchurl srcs.${system};

    nativeBuildInputs = lib.optional stdenv.isLinux autoPatchelfHook;

    dontUnpack = true;
    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      install -m755 -D $src $out/bin/ollama
      runHook postInstall
    '';

    meta = {
      homepage = "https://ollama.ai/";
      downloadPage = "${repo}/releases";
      description = "Get up and running with Llama 2 and other large language models locally";
      mainProgram = pname;
      platforms = builtins.attrNames srcs;
      license = lib.licenses.mit;
      changelog = "${repo}/releases/tag/v${version}";
    };
  }
