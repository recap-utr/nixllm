# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/python-modules/litellm/default.nix
{
  lib,
  fetchPypi,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "litellm";
  version = "0.14.0.dev1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q5Ab90pthD8yknue04Y2VQH8NHEGsAiZLWe2VgnDFig=";
  };

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    # base: https://github.com/BerriAI/litellm/blob/main/pyproject.toml
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
    # proxy: https://github.com/BerriAI/litellm/blob/main/litellm/proxy/proxy_server.py
    uvicorn
    fastapi
    tomli
    appdirs
    tomli-w
    backoff
    pyyam
  ];

  doCheck = false;

  meta = {
    description = "Call all LLM APIs using the OpenAI format. Use Bedrock, Azure, OpenAI, Cohere, Anthropic, Ollama, Sagemaker, HuggingFace, Replicate (100+ LLMs)";
    homepage = "https://litellm.ai";
    downloadPage = "https://github.com/BerriAI/litellm/releases";
    license = lib.licenses.mit;
    mainProgram = "litellm";
    changelog = "https://github.com/BerriAI/litellm/releases/tag/v${version}";
  };
}
