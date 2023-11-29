# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/python-modules/litellm/default.nix
{
  lib,
  fetchPypi,
  python3Packages,
}: let
  pname = "litellm";
  version = "1.7.12";
in
  python3Packages.buildPythonApplication {
    inherit pname version;
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-mpPAx2tNqDYnINlCVV6/A7A1ySIVVjnWIU+O0OmdxHo=";
    };

    nativeBuildInputs = with python3Packages; [
      poetry-core
    ];

    propagatedBuildInputs =
      # base: https://github.com/BerriAI/litellm/blob/main/pyproject.toml
      (with python3Packages; [
        openai
        python-dotenv
        tiktoken
        importlib-metadata
        tokenizers
        click
        jinja2
        certifi
        appdirs
        aiohttp
      ])
      # proxy: https://github.com/BerriAI/litellm/blob/main/litellm/proxy/proxy_server.py
      ++ (with python3Packages; [
        uvicorn
        fastapi
        appdirs
        backoff
        pyyaml
        rq
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
