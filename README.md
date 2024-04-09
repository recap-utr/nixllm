# nixllm

Nix wrapper for running LLMs behind an OpenAI-compatible API proxy.

> [!important]
> This project is not designed to be used on NixOS, we do not use `patchelf` since that caused issues with the CUDA runtime.
> Instead, it is intended to be used with the `nix` package manager on other Linux distributions like Ubuntu.
> You may use it together with [`nix-ld`](https://github.com/Mic92/nix-ld) on NixOS.

## Ollama Usage

```shell
# make sure to pull the models first
nix run github:recap-utr/nixllm#ollama -- pull MODEL_NAME
CUDA_VISIBLE_DEVICES=0 OLLAMA_HOST=0.0.0.0:6060 nix run github:recap-utr/nixllm#ollama -- serve
```
