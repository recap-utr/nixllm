# https://github.com/NixOS/nixpkgs/pull/250927
{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  which,
  ninja,
  packaging,
  setuptools,
  torch,
  wheel,
  psutil,
  ray,
  pandas,
  pyarrow,
  sentencepiece,
  numpy,
  transformers,
  xformers,
  fastapi,
  uvicorn,
  pydantic,
  pybind11,
}: let
  version = "0.2.1.post1";
in
  buildPythonPackage {
    pname = "vllm";
    inherit version;
    pyproject = true;

    src = fetchFromGitHub {
      owner = "vllm-project";
      repo = "vllm";
      rev = "v${version}";
      hash = "sha256-vkrh0rOjOvz0hOWlK+EVB3iCMJfxlau8m+afwp0HBzU=";
    };

    preBuild = ''
      export CUDA_HOME=${torch.passthru.cudaPackages.cuda_nvcc}
    '';

    nativeBuildInputs = [
      ninja
      packaging
      setuptools
      torch
      wheel
      which
    ];

    propagatedBuildInputs = [
      ninja
      psutil
      ray
      pandas
      pyarrow
      sentencepiece
      numpy
      torch
      transformers
      xformers
      fastapi
      uvicorn
      pydantic
    ];

    pythonImportsCheck = ["vllm"];

    meta = {
      description = "A high-throughput and memory-efficient inference and serving engine for LLMs";
      changelog = "https://github.com/vllm-project/vllm/releases/tag/v${version}";
      homepage = "https://github.com/vllm-project/vllm";
      license = lib.licenses.asl20;
    };
  }
