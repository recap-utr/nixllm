{
  fetchzip,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {

  pname = "ollama-bin";
  version = "0.3.12";

  src = fetchzip {
    url = "https://github.com/ollama/ollama/releases/download/v${version}/ollama-linux-amd64.tgz";
    hash = "sha256-tiD6vQgoisojEjUbKY6h10NHJGmJjC0MSxgpdmI7Y+0=";
    stripRoot = false;
  };

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    install -m755 -D $src/bin/ollama $out/bin/ollama
    runHook postInstall
  '';

  meta = {
    homepage = "https://ollama.ai/";
    downloadPage = "https://github.com/ollama/ollama/releases";
    description = "Get up and running with Llama 2 and other large language models locally";
    mainProgram = "ollama";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    changelog = "https://github.com/ollama/ollama/releases/tag/v${version}";
  };
}
