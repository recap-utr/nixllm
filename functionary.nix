# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/python-modules/litellm/default.nix
{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonPackage {
  name = "functionary";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "MeetKai";
    repo = "functionary";
    rev = "9a2862cd68d7e5fbce2581f16704923cde7051c4";
    hash = "sha256-Bsx0mZ9sOCKrkq03y0HrJ06YBUzTL/yvC4NkB4ig/pU=";
  };

  propagatedBuildInputs = with python3Packages; [
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

  meta = {
    description = "Chat language model that can interpret and execute functions/plugins";
    homepage = "https://github.com/MeetKai/functionary";
    license = lib.licenses.mit;
    mainProgram = "functionary";
  };
}
