{
  callPackage,
  lib,
  stdenv,
  autoPatchelfHook,
  generated,
  avxVersion ? "avx512",
}: let
  inherit (stdenv.hostPlatform) system;
  pname = "local-ai";
  drv = generated."${pname}-${system}-${avxVersion}";
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
      changelog = "https://github.com/mudler/LocalAI/releases/tag/v${drv.version}";
    };
  }
