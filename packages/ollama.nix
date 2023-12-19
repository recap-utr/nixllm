{
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
}: let
  inherit (stdenv.hostPlatform) system;
  pname = "ollama";
  version = "0.1.17";
  repo = "https://github.com/jmorganca/ollama";
  srcs = rec {
    x86_64-linux = {
      url = "${repo}/releases/download/v${version}/${pname}-linux-amd64";
      hash = "sha256-t33uwWlqVJC7lCN4n/4nRxPG1ipnGc31Cxr9lR4jxws=";
    };
    aarch64-linux = {
      url = "${repo}/releases/download/v${version}/${pname}-linux-arm64";
      hash = "sha256-HfzNeg9sfhKvEEIMndsE1UVU1jnOSK17VrY7LXCJc9A=";
    };
    x86_64-darwin = {
      url = "${repo}/releases/download/v${version}/${pname}-darwin";
      hash = "sha256-KeJabUn5Gxb/m79LUh13Qhm4g8+GJ23iuWeEzI7dIRk=";
    };
    aarch64-darwin = x86_64-darwin;
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
