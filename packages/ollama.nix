{
  fetchurl,
  lib,
  stdenvNoCC,
}: let
  pname = "ollama";
  version = "0.1.20";
  repo = "https://github.com/jmorganca/ollama";
  url = "${repo}/releases/download/v${version}/${pname}-linux-amd64";
in
  stdenvNoCC.mkDerivation {
    inherit pname version url;

    src = fetchurl {
      inherit url;
      hash = "sha256-XR4lYh7k5yAtkUqwwjeZOnSdP+qarBk0XozWyD9uBaE=";
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
      downloadPage = "${repo}/releases";
      description = "Get up and running with Llama 2 and other large language models locally";
      mainProgram = pname;
      platforms = ["x86_64-linux"];
      license = lib.licenses.mit;
      changelog = "${repo}/releases/tag/v${version}";
    };
  }
