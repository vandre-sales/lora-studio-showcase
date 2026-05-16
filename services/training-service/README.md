# training-service — Dispatch, Monitoring & Checkpoints

**Domain:** Training Orchestration
**Role:** Dispatch training jobs, monitor progress, manage checkpoints

## Responsibilities

- Dispatch training jobs to compute providers (Replicate API, local GPU, SageMaker)
- Poll training status and stream loss curve via WebSocket
- Save checkpoints at configurable intervals
- Allow DS to select optimal checkpoint (not always the last one)
- Pre-training validation gate: reject if violations > 0

## Provider Adapter Pattern

The training-service abstracts compute providers behind a pluggable interface:

| Provider | Implementation | Use Case |
|---|---|---|
| **Replicate** (default) | REST API to `fast-flux-trainer` | Cloud training without GPU management |
| **AWS SageMaker** | SageMaker Training Jobs API | Enterprise AWS-native training |
| **GCP Vertex AI** | Vertex AI Custom Training | GCP-native equivalent |
| **Azure ML** | Azure ML Pipelines | Azure-native equivalent |
| **Local GPU** | Direct CUDA execution | Development and testing |

Swapping providers requires implementing a new adapter — zero pipeline changes.

## GPU Requirements

| GPU | VRAM | Min for LoRA Training | Provider |
|---|---|---|---|
| NVIDIA A10G | 24GB | ✅ (with `low_vram: true`) | AWS G5 |
| NVIDIA A100 | 80GB | ✅ (recommended) | AWS P4d, GCP A2 |
| NVIDIA H100 | 80GB | ✅ (optimal) | AWS P5, GCP A3 |
| NVIDIA RTX PRO 6000 | 96GB | ✅ (optimal) | AWS G7E |

## Training Job Status Machine

```
QUEUED → DISPATCHED → RUNNING → COMPLETED | FAILED | CANCELLED
```

## Key Endpoints

| Method | Path | Description | Auth |
|---|---|---|---|
| POST | `/api/v1/training-jobs` | Dispatch training | JWT (DS)/Service |
| GET | `/api/v1/training-jobs/{id}` | Job status | JWT |
| GET | `/api/v1/training-jobs/{id}/loss-curve` | Loss history | JWT (DS) |
| GET | `/api/v1/training-jobs/{id}/checkpoints` | List checkpoints | JWT (DS) |
| POST | `/api/v1/training-jobs/{id}/select-checkpoint` | Select best checkpoint | JWT (DS) |
| POST | `/api/v1/training-jobs/{id}/cancel` | Cancel training | JWT (DS) |

→ Full spec: [api-spec.yaml](api-spec.yaml) · Schema: [schema.sql](schema.sql)
