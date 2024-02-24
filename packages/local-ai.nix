{
  fetchurl,
  lib,
  stdenvNoCC,
  avxVersion ? "avx512",
}:
let
  pname = "local-ai";
  version = "2.9.0";
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/mudler/LocalAI/releases/download/v${version}/${pname}-${avxVersion}-Linux-x86_64";
    hash = "sha256-/L0WFKEXXGsJC2ZRAzlfnxzyE5LQmmKS0L9NOwKGZOo=";
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
    downloadPage = "https://github.com/mudler/LocalAI/releases";
    description = "Get up and running with Llama 2 and other large language models locally";
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    changelog = "https://github.com/mudler/LocalAI/releases/tag/v${version}";
  };
}
