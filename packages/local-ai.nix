{
  fetchurl,
  lib,
  stdenvNoCC,
  avxVersion ? "avx512",
}: let
  pname = "local-ai";
  version = "2.5.1";
  repo = "https://github.com/mudler/LocalAI";
  url = "${repo}/releases/download/v${version}/${pname}-${avxVersion}-Linux-x86_64";
in
  stdenvNoCC.mkDerivation {
    inherit pname version url;

    src = fetchurl {
      inherit url;
      hash = "sha256-a87QsIbiC2f/ZjVnMnyM60YrwhKFUxzrzLDCMVn62y4=";
    };

    dontUnpack = true;
    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      install -m755 -D $src $out/bin/${pname}
      runHook postInstall
    '';

    meta = {
      homepage = "https://localai.io/";
      downloadPage = "${repo}/releases";
      description = "Get up and running with Llama 2 and other large language models locally";
      mainProgram = pname;
      platforms = ["x86_64-linux"];
      license = lib.licenses.mit;
      changelog = "${repo}/releases/tag/v${version}";
    };
  }
