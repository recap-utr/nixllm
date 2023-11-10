{
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "ollama";
  version = "0.1.9";
  src = fetchurl {
    url = "https://github.com/jmorganca/ollama/releases/download/v${version}/ollama-linux-amd64";
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
    platforms = ["x86_64-linux"];
  };
}