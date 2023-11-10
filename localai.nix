{
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "ollama";
  version = "1.40.0";
  src = fetchurl {
    url = "https://github.com/mudler/LocalAI/releases/download/v${version}/local-ai-avx512-Linux-x86_64";
    hash = "sha256-ITdEn96zy3P9GPikOujGb4/AzsESWVOn5c9vrh+LEgY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m755 -D $src $out/bin/localai
  '';

  meta = {
    homepage = "https://localai.io/";
    downloadPage = "https://github.com/mudler/LocalAI/releases";
    description = "Get up and running with Llama 2 and other large language models locally";
    mainProgram = "localai";
    platforms = ["x86_64-linux"];
  };
}
