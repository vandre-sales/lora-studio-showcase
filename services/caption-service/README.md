# caption-service — Auto-Captioning & Violation Detection

**Domain:** Dataset Engineering
**Role:** Generate, edit, and validate captions for LoRA training datasets

## Responsibilities

- Auto-caption images via Vision LLM with brand-aware system prompts
- Inline caption editing for Data Scientists
- Real-time LOCKED violation scanner (<200ms per caption)
- Batch validation before training dispatch
- Token count validation (50–200 tokens via T5 tokenizer)

## Auto-Captioning Logic

1. Receive `dataset_id` + `lora_config_id`
2. Fetch config from config-service: trigger, class_word, locked_terms, type
3. For each image: send to Vision LLM with system prompt: *"Describe ONLY UNLOCKED attributes. NEVER mention: [locked_terms]"*
4. Prepend `{trigger} {class_word}.` to each caption
5. Validate token count (50–200) and scan for violations
6. Emit event `captions.generated`

## Violation Scanner

Uses **word-boundary regex** (`\b{term}\b`), NOT substring matching.

This prevents false positives: "red" inside "mirrored", "art" inside "smart", "age" inside "signage".

Response time target: **<200ms** for single caption validation (real-time editor feedback).

## Key Endpoints

| Method | Path | Description | Auth |
|---|---|---|---|
| POST | `/api/v1/captioning-jobs` | Dispatch auto-captioning | JWT/Service |
| GET | `/api/v1/captions` | List captions by dataset | JWT |
| PATCH | `/api/v1/captions/{id}` | Edit caption inline | JWT (DS) |
| POST | `/api/v1/captions/bulk-edit` | Find/replace across captions | JWT (DS) |
| POST | `/api/v1/captions/validate` | Batch scan for violations | JWT |
| POST | `/api/v1/captions/validate-single` | Real-time single caption scan | JWT (DS) |

→ Full spec: [api-spec.yaml](api-spec.yaml) · Schema: [schema.sql](schema.sql)
