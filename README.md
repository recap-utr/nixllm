# nixllm

Nix wrapper for running LLMs behind an OpenAI-compatible API proxy.

> [!important]
> This project is not designed to be used on NixOS, we do not use `patchelf` since that caused issues with the CUDA runtime.
> Instead, it is intended to be used with the `nix` package manager on other Linux distributions like Ubuntu.
> You may use it together with [`nix-ld`](https://github.com/Mic92/nix-ld) on NixOS.

## Usage

### LiteLLM with Ollama

```shell
CUDA_VISIBLE_DEVICES=7 nix run github:recap-utr/nixllm#litellm -- --model ollama/llama2:13b --port 6060 --num_workers 4 --add_function_to_prompt
```

### Ollama Standalone

```shell
CUDA_VISIBLE_DEVICES=7 OLLAMA_HOST=0.0.0.0:6060 nix run github:recap-utr/nixllm#ollama -- serve
```

### LocalAI

```shell
CUDA_VISIBLE_DEVICES=7 nix run github:recap-utr/nixllm#localai -- --address=0.0.0.0:6060 --galleries='[{"name":"nixllm","url":"file://local-ai/gallery.yaml"}]'
# download models for the first time
curl http://IP:6060/models/apply -H "Content-Type: application/json" -d '{"id": "nixllm@llama2-13b"}'
```
