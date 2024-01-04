{
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
  avxVersion ? "avx512",
}: let
  pname = "local-ai";
  version = "2.1.0";
  repo = "https://github.com/mudler/LocalAI";
  url = "${repo}/releases/download/v${version}/${pname}-${avxVersion}-Linux-x86_64";
in
  stdenv.mkDerivation {
    inherit pname version url;

    src = fetchurl {
      inherit url;
      hash = "sha256-o77g4aFBXnw4/8F2jFob3G9FU1e+ltT0H6tvyZRhuY8=";
    };

    nativeBuildInputs = lib.optional stdenv.isLinux autoPatchelfHook;

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
