# https://gist.github.com/mausch/f525326eb70528f04b626fb9e01fcb58
{
  lib,
  fetchFromGitHub,
  fetchurl,
  python3Packages,
  cmake,
  ninja,
  # custom
  llama-cpp,
}: let
  pname = "llama-cpp-python";
  version = "0.2.18";
  model = fetchurl {
    url = "https://huggingface.co/TheBloke/Llama-2-13B-chat-GGUF/resolve/main/llama-2-13b-chat.Q4_K_M.gguf";
    hash = "sha256-fd/if2G/mUVCwirKITxG7L2KYkzKdKv/Aqe1qMGPeH8=";
  };
in
  python3Packages.buildPythonApplication {
    inherit pname version;
    pyproject = true;

    src = fetchFromGitHub {
      owner = "abetlen";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-kUoc61tSS7ohAl7vIN6Yt/TV1RLQg45QZXpff/URImA=";
    };

    buildInputs = [
      cmake
    ];

    nativeBuildInputs = with python3Packages; [
      llama-cpp
      scikit-build-core
      cmake
      ninja
    ];

    propagatedBuildInputs = with python3Packages; [
      # regular
      numpy
      typing-extensions
      diskcache
      # server
      uvicorn
      fastapi
      pydantic-settings
      # sse-starlette
      # starlette-context
    ];

    meta = {
      description = "Python bindings for llama.cpp";
      homepage = "https://github.com/abetlen/llama-cpp-python";
      downloadPage = "https://pypi.org/project/llama-cpp-python";
      license = lib.licenses.mit;
      mainProgram = "llama_cpp";
    };
  }
