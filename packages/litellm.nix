# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/python-modules/litellm/default.nix
{
  lib,
  fetchPypi,
  python3Packages,
}: let
  pname = "litellm";
  version = "1.16.12";
in
  python3Packages.buildPythonApplication {
    inherit pname version;
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-jtzBUyB0eduAvOEnhZxjWpf9JI46BTayiEyghN90viA=";
    };

    nativeBuildInputs = with python3Packages; [
      poetry-core
    ];

    # https://github.com/BerriAI/litellm/blob/main/pyproject.toml
    propagatedBuildInputs =
      # base
      (with python3Packages; [
        openai
        python-dotenv
        tiktoken
        importlib-metadata
        tokenizers
        click
        jinja2
        certifi
        aiohttp
      ])
      # proxy
      ++ (with python3Packages; [
        uvicorn
        fastapi
        backoff
        pyyaml
        rq
        orjson
      ]);

    doCheck = false;

    meta = {
      description = "Call all LLM APIs using the OpenAI format. Use Bedrock, Azure, OpenAI, Cohere, Anthropic, Ollama, Sagemaker, HuggingFace, Replicate (100+ LLMs)";
      homepage = "https://litellm.ai";
      downloadPage = "https://pypi.org/project/litellm/#history";
      license = lib.licenses.mit;
      mainProgram = "litellm";
      changelog = "https://github.com/BerriAI/litellm/releases/tag/v${version}";
    };
  }
