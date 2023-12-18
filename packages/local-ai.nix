{
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
  avxVersion ? "avx512",
}: let
  inherit (stdenv.hostPlatform) system;
  pname = "local-ai";
  version = "2.1.0";
  repo = "https://github.com/mudler/LocalAI";
  srcs = {
    "x86_64-linux" = {
      url = "${repo}/releases/download/v${version}/${pname}-${avxVersion}-Linux-x86_64";
      hash = "sha256-o77g4aFBXnw4/8F2jFob3G9FU1e+ltT0H6tvyZRhuY8=";
    };
    "x86_64-darwin" = {
      url = "${repo}/releases/download/v${version}/${pname}-${avxVersion}-Darwin-x86_64";
      hash = "sha256-0zd+XsEUvUstGJ9QnbhJoMbvhpU2sNVd9/qeupqUK9c=";
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
