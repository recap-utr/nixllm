# nixllm

Nix wrapper for running LLMs behind an OpenAI-compatible API proxy.

> [!important]
> This project is not designed to be used on NixOS, we do not use `patchelf` since that caused issues with the CUDA runtime.
> Instead, it is intended to be used with the `nix` package manager on other Linux distributions like Ubuntu.
> On these distributions, the dynamic libraries are already in the correct location, so there is no need to patch them.

## Usage

The examples assume that the Git repo has been cloned.
To run it without cloning, replace `nix run .#PACKAGE` with `nix run github:recap-utr/nixllm#PACKAGE`

### Ollama

```console
CUDA_VISIBLE_DEVICES=7 OLLAMA_HOST=0.0.0.0:50900 nix run .#ollama -- serve
```

### LiteLLM

```console
CUDA_VISIBLE_DEVICES=7 nix run .#litellm -- --model ollama/llama2:13b --port 50900 --num_workers 4 --add_function_to_prompt
```

### LocalAI

```console
CUDA_VISIBLE_DEVICES=7 nix run .#localai -- --address=0.0.0.0:50900 --galleries='[{"name":"nixllm","url":"file://local-ai/gallery.yaml"}]'
# download models for the first time
curl http://IP:50910/models/apply -H "Content-Type: application/json" -d '{"id": "nixllm@llama2-13b"}'
```

### Functionary

```shell
CUDA_VISIBLE_DEVICES=7 nix run .#functionary -- --port 50900 --device cuda
```
