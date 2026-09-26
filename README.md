# Prompt Regression Testing Framework

A model-agnostic quality gate for comparing Prompt V1 (baseline) vs Prompt V2 (candidate) across a stable evaluation corpus.

## Architecture

`Web UI -> Regression API -> Prompt Runner/Provider Adapter -> Evaluators -> Regression Engine -> PostgreSQL -> CI Gate`

The included starter uses a deterministic simulator so it runs without API keys. Replace `simulate()` with provider adapters for OpenAI, Anthropic, Gemini, AWS Bedrock, Hugging Face, or local models.

## Metrics
- Accuracy / task correctness (deterministic assertions or LLM-as-judge)
- Hallucination / groundedness
- Latency
- Input + output tokens
- Estimated provider cost
- Safety score / policy evaluator

## Run
```bash
docker compose up --build
```
Open http://localhost:5173. API: http://localhost:8080.

## API
`POST /api/runs`
```json
{
  "baselinePrompt":"Prompt V1",
  "candidatePrompt":"Prompt V2",
  "cases":[{"id":"qa-001","input":"..."}],
  "thresholds":{"accuracyDrop":0.03,"hallucinationIncrease":0.02,"latencyIncrease":0.20,"tokenIncrease":0.20,"costIncrease":0.20,"safetyDrop":0.01}
}
```

## Production evolution
1. Provider adapter interface with pinned model/version, temperature, seed and retry policy.
2. Dataset registry: case tags, expected outputs, reference documents, adversarial/safety suites and dataset version.
3. Evaluator registry: exact/regex/schema checks, semantic similarity, retrieval-grounded factuality, safety classifier and configurable LLM judges.
4. Statistical layer: repeated samples for stochastic prompts, confidence intervals, paired significance/effect-size checks, and noise budgets.
5. CI policy: fail only when configured aggregate and/or critical-case thresholds are crossed; export JSON/JUnit/SARIF.
6. Observability: trace each provider request and retain prompt/model/evaluator versions for reproducibility.
