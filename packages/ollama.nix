{
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
}: let
  pname = "ollama";
  version = "0.1.18";
  repo = "https://github.com/jmorganca/ollama";
  url = "${repo}/releases/download/v${version}/${pname}-linux-amd64";
in
  stdenv.mkDerivation {
    inherit pname version url;

    src = fetchurl {
      inherit url;
      hash = "sha256-bEtjSCl520uvJhPuhsl4eSDAr8th3zm0n1YJxL/mTXc=";
    };

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
      downloadPage = "${repo}/releases";
      description = "Get up and running with Llama 2 and other large language models locally";
      mainProgram = pname;
      platforms = ["x86_64-linux"];
      license = lib.licenses.mit;
      changelog = "${repo}/releases/tag/v${version}";
    };
  }
