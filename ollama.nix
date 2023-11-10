{
  system,
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
}: let
  platforms = {
    x86_64-linux = "linux-amd64";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin";
    aarch64-darwin = "darwin";
  };
  platform = platforms.${system};
in
  stdenv.mkDerivation rec {
    pname = "ollama";
    version = "0.1.9";
    src = fetchurl {
      url = "https://github.com/jmorganca/ollama/releases/download/v${version}/${pname}-${platform}";
      hash = "sha256-ghEkGZN4uhKkHUCXTiTzllerbg+kNdWQznaX7aPsLAU=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
    ];

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
      downloadPage = "https://github.com/jmorganca/ollama/releases";
      description = "Get up and running with Llama 2 and other large language models locally";
      mainProgram = "ollama";
      platforms = builtins.attrNames platforms;
      license = lib.licenses.mit;
      changelog = "https://github.com/jmorganca/ollama/releases/tag/v${version}";
    };
  }
