{
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
}: let
  inherit (stdenv.hostPlatform) system;
  pname = "local-ai";
  version = "1.40.0";
  avxVersion = "avx512";
  repo = "https://github.com/mudler/LocalAI";
  srcs = {
    "x86_64-linux" = {
      url = "${repo}/releases/download/v${version}/${pname}-${avxVersion}-Linux-x86_64";
      hash = "sha256-ITdEn96zy3P9GPikOujGb4/AzsESWVOn5c9vrh+LEgY=";
    };
    "x86_64-darwin" = {
      url = "${repo}/releases/download/v${version}/${pname}-${avxVersion}-Darwin-x86_64";
      hash = "sha256-MRoiKFwAZEoKOf+nOMVl+75+ceSKrm1VnuwWK9n1/eY=";
    };
  };
in
  stdenv.mkDerivation {
    inherit pname version;

    passthru = {
      inherit srcs;
    };

    src = fetchurl srcs.${system};

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
      platforms = builtins.attrNames srcs;
      license = lib.licenses.mit;
      changelog = "${repo}/releases/tag/v${version}";
    };
  }
