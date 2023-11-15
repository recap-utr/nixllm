# nixllm

Nix wrapper for running LLMs behind an OpenAI-compatible API proxy.

## Usage

### LiteLLM

```shell
CUDA_VISIBLE_DEVICES=7 nix run .#litellm -- --model ollama/llama2:13b --port 50900 --num_workers 8 --add_function_to_prompt
```

### LocalAI

```shell
CUDA_VISIBLE_DEVICES=7 nix run .#localai -- --address=0.0.0.0:50900 --galleries='[{"name":"nixllm","url":"file://local-ai/gallery.yaml"}]'
# download models for the first time
curl http://IP:50910/models/apply -H "Content-Type: application/json" -d '{"id": "nixllm@llama2-13b"}'
```
