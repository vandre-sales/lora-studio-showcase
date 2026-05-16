# config-service — LoRA Registry (SSoT)

**Domain:** Training Orchestration
**Role:** Single Source of Truth for all LoRA configurations

This is the most critical service in the platform. It centralizes every LoRA's trigger word, class word, locked terms, hyperparameters, and inference strengths. All other services consult config-service before making decisions.

## Responsibilities

- Auto-generate trigger words (9 chars a-z, validated against T5+CLIP tokenizers)
- Auto-calculate hyperparameters based on LoRA type and dataset size
- Store Locked Attributes Card (LAC) as the canonical violation dictionary
- Maintain the LoRA Registry for multi-LoRA composition at inference
- Validate trigger tokenization (≤2 tokens in both T5-XXL and CLIP ViT-L/14)

## Key Endpoints

| Method | Path | Description | Auth |
|---|---|---|---|
| POST | `/api/v1/lora-configs` | Create new config (auto-generates trigger + hyperparams) | JWT |
| GET | `/api/v1/lora-configs/{id}` | Get full config (trigger, class, rank, alpha, steps, locked_terms) | JWT |
| PATCH | `/api/v1/lora-configs/{id}` | DS override hyperparameters | JWT (DS) |
| POST | `/api/v1/lora-configs/{id}/validate-trigger` | Validate trigger tokenization | JWT |
| GET | `/api/v1/lora-configs` | List configs by project | JWT |
| GET | `/api/v1/lora-registry` | Global registry of production LoRAs | JWT |

→ Full spec: [api-spec.yaml](api-spec.yaml) · Schema: [schema.sql](schema.sql)

## Auto-Generate Trigger Word

Schema: `[CLIENT:2][TYPE:3][SEQ:1][ID:3]` = 9 chars a-z

Validation: exactly 9 chars, a-z only, not a real word, ≤2 tokens T5 AND ≤2 tokens CLIP, unique per org.

## Auto-Calculate Hyperparameters

| Parameter | Formula | Example (80 imgs persona) |
|---|---|---|
| steps | N_images × 40 (min 1000, max 5000) | 3200 |
| rank | By type: persona=32, logo=64, style=32, color=16 | 32 |
| alpha | = rank (default) | 32 |
| lr | 1e-4 (fixed for Flux) | 1e-4 |
| optimizer | adamw8bit | adamw8bit |
| ema | { use_ema: true, decay: 0.99 } | true |
| train_text_encoder | false (mandatory for Flux) | false |
| inference_strength | By type: persona=0.85, style=0.70, logo=0.65, color=0.55 | 0.85 |

## GPU Requirements

Training requires NVIDIA GPUs with ≥24GB VRAM. Compatible hardware:

| GPU | VRAM | Provider (AWS) | Provider (GCP) | Provider (Azure) |
|---|---|---|---|---|
| NVIDIA A100 | 80GB HBM2e | EC2 P4d | A2 | NC A100 v4 |
| NVIDIA H100 | 80GB HBM3 | EC2 P5 | A3 | ND H100 v5 |
| NVIDIA RTX PRO 6000 | 96GB GDDR7 | EC2 G7E | — | — |
| NVIDIA A10G | 24GB | EC2 G5 | G2 (L4) | NC T4 v3 |
