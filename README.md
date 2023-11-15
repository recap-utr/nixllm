# nixllm

Nix wrapper for running LLMs behind an OpenAI-compatible API proxy.

## Usage
```

### LocalAI

```shell
CUDA_VISIBLE_DEVICES=7 nix run .#localai -- --address=0.0.0.0:50900 --galleries='[{"name":"nixllm","url":"file://local-ai/gallery.yaml"}]'
# download models for the first time
curl http://136.199.130.136:50910/models/apply -H "Content-Type: application/json" -d '{"id": "nixllm@llama2-13b"}'
```
