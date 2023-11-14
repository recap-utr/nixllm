{
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
  avxVersion ? "avx512",
}: let
  inherit (stdenv.hostPlatform) system;
  pname = "local-ai";
  version = "1.39.0";
  srcs = {
    "x86_64-linux" = fetchurl {
      url = "https://github.com/mudler/LocalAI/releases/download/v${version}/local-ai-${avxVersion}-Linux-x86_64";
      hash = "";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://github.com/mudler/LocalAI/releases/download/v${version}/local-ai-${avxVersion}-Darwin-x86_64";
      hash = "";
    };
  };
in
  stdenv.mkDerivation {
    inherit pname version;

    src = srcs.${system};

    nativeBuildInputs = lib.optional stdenv.isLinux autoPatchelfHook;

    dontUnpack = true;
    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      install -m755 -D $src $out/bin/local-ai
      runHook postInstall
    '';

    meta = {
      homepage = "https://localai.io/";
      downloadPage = "https://github.com/mudler/LocalAI/releases";
      description = "Get up and running with Llama 2 and other large language models locally";
      mainProgram = "local-ai";
      platforms = ["x86_64-linux" "x86_64-darwin"];
      license = lib.licenses.mit;
      changelog = "https://github.com/mudler/LocalAI/releases/tag/v${version}";
    };
  }
