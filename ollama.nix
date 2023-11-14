{
  callPackage,
  lib,
  stdenv,
  autoPatchelfHook,
  generated,
}: let
  inherit (stdenv.hostPlatform) system;
  pname = "ollama";
  drv = generated."${pname}-${system}";
in
  stdenv.mkDerivation {
    inherit pname;
    inherit (drv) src version;

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
      downloadPage = "https://github.com/jmorganca/ollama/releases";
      description = "Get up and running with Llama 2 and other large language models locally";
      mainProgram = "ollama";
      platforms = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
      license = lib.licenses.mit;
      changelog = "https://github.com/jmorganca/ollama/releases/tag/v${drv.version}";
    };
  }
