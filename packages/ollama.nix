{
  fetchurl,
  lib,
  stdenvNoCC,
}:
let
  pname = "ollama";
  version = "0.1.27";
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/ollama/ollama/releases/download/v${version}/${pname}-linux-amd64";
    hash = "sha256-ptotswa6QcCVp0fmNiEwL+gp3CGpyY24wC+d+mqlPm4=";
  };

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
    downloadPage = "https://github.com/ollama/ollama/releases";
    description = "Get up and running with Llama 2 and other large language models locally";
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    changelog = "https://github.com/ollama/ollama/releases/tag/v${version}";
  };
}
