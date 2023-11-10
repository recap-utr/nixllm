{
  system,
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
  avxVersion ? "avx512",
}: let
  platforms = {
    x86_64-linux = "Linux-x86_64";
    x86_64-darwin = "Darwin_x86_64";
  };
  platform = platforms.${system};
in
  stdenv.mkDerivation rec {
    pname = "local-ai";
    version = "1.40.0";
    src = fetchurl {
      url = "https://github.com/mudler/LocalAI/releases/download/v${version}/${pname}-${avxVersion}-${platform}";
      hash = "sha256-ITdEn96zy3P9GPikOujGb4/AzsESWVOn5c9vrh+LEgY=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    dontUnpack = true;
    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      install -m755 -D $src $out/bin/local-ai
      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://localai.io/";
      downloadPage = "https://github.com/mudler/LocalAI/releases";
      description = "Get up and running with Llama 2 and other large language models locally";
      mainProgram = "local-ai";
      platforms = builtins.attrNames platforms;
      license = lib.licenses.mit;
      changelog = "https://github.com/mudler/LocalAI/releases/tag/v${version}";
    };
  }
