{
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
}: let
  inherit (stdenv.hostPlatform) system;
  pname = "ollama";
  version = "0.1.9";
  repo = "https://github.com/jmorganca/ollama";
  srcs = {
    x86_64-linux = {
      url = "${repo}/releases/download/v${version}/${pname}-linux-amd64";
      hash = "sha256-ghEkGZN4uhKkHUCXTiTzllerbg+kNdWQznaX7aPsLAU=";
    };
    aarch64-linux = {
      url = "${repo}/releases/download/v${version}/${pname}-linux-arm64";
      hash = "sha256-J6NJ+UrVdcU/sg/YxOA53vkxLVgQ36nVm+sMMBzZxQc=";
    };
    x86_64-darwin = {
      url = "${repo}/releases/download/v${version}/${pname}-darwin";
      hash = "sha256-htTv84CJ++xZxQc1NGd5x2D637xdaZStSRVi323Exxg=";
    };
    aarch64-darwin = {
      url = "${repo}/releases/download/v${version}/${pname}-darwin";
      hash = "sha256-htTv84CJ++xZxQc1NGd5x2D637xdaZStSRVi323Exxg=";
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
      install -m755 -D $src $out/bin/ollama
      runHook postInstall
    '';

    meta = {
      homepage = "https://ollama.ai/";
      downloadPage = "${repo}/releases";
      description = "Get up and running with Llama 2 and other large language models locally";
      mainProgram = pname;
      platforms = builtins.attrNames srcs;
      license = lib.licenses.mit;
      changelog = "${repo}/releases/tag/v${version}";
    };
  }
