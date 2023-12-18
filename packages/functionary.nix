# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/python-modules/litellm/default.nix
{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  torch,
  transformers,
  accelerate,
  sentencepiece,
  fastapi,
  uvicorn,
  pydantic,
  scipy,
  jsonref,
  requests,
  pyyaml,
  typer,
  protobuf,
  tokenizers,
}: let
  pname = "functionary";
  version = "dev";
in
  buildPythonPackage {
    inherit pname version;
    pyproject = false;

    src = fetchFromGitHub {
      owner = "MeetKai";
      repo = "functionary";
      rev = "9a2862cd68d7e5fbce2581f16704923cde7051c4";
      hash = "sha256-Bsx0mZ9sOCKrkq03y0HrJ06YBUzTL/yvC4NkB4ig/pU=";
    };

    nativeBuildInputs = [setuptools wheel torch];

    propagatedBuildInputs = [
      torch
      # requirements.txt
      transformers
      accelerate
      sentencepiece
      fastapi
      uvicorn
      pydantic
      scipy
      jsonref
      requests
      pyyaml
      typer
      protobuf
      tokenizers
    ];

    doCheck = false;

    patchPhase = ''
      echo <<EOL >> setup.py
      from setuptools import setup, find_packages
      setup(
          name="${pname}",
          version="${version}",
          packages=find_packages(),
      )
      EOL
    '';

    meta = {
      description = "Chat language model that can interpret and execute functions/plugins";
      homepage = "https://github.com/MeetKai/functionary";
      license = lib.licenses.mit;
      mainProgram = "functionary";
    };
  }
