# nixllm

Nix wrapper for running LLMs behind an OpenAI-compatible API proxy.

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
