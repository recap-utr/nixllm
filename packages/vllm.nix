# https://github.com/NixOS/nixpkgs/pull/250927
{
  lib,
  fetchPypi,
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
  aioprometheus,
}: let
  pname = "vllm";
  version = "0.2.6";
in
  buildPythonPackage {
    inherit pname version;
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = lib.fakeHash;
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

    propagatedBuildInputs =
      [
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
        aioprometheus
      ]
      ++ uvicorn.optional-dependencies.standard
      ++ aioprometheus.optional-dependencies.starlette;

    pythonImportsCheck = ["vllm"];

    meta = {
      description = "A high-throughput and memory-efficient inference and serving engine for LLMs";
      changelog = "https://github.com/vllm-project/vllm/releases/tag/v${version}";
      homepage = "https://github.com/vllm-project/vllm";
      license = lib.licenses.asl20;
    };
  }
