# Glossary — ML Terms for Non-ML Developers

This glossary explains technical terms used throughout the LoRA Studio architecture documentation. Designed for software engineers who may not have machine learning background.

| Term | Definition | Where Used |
|---|---|---|
| **LoRA** | Low-Rank Adaptation — a technique that adds small trainable matrices (B × A) to a pre-trained AI model, allowing fine-tuning without modifying original weights. Output: a `.safetensors` file (50–300 MB) | Entire platform |
| **safetensors** | Standard file format for storing LoRA model weights. Binary, secure, does not execute code | deploy-service, training-service |
| **Trigger Word** | An artificial 9-character string (a-z) that the model learns to associate with a visual concept. Activates the trained identity at inference | config-service |
| **Class Word** | A real word that anchors the trigger in the model's semantic space. Examples: "woman", "logo", "store" | config-service |
| **LOCKED Attribute** | A permanent visual attribute (age, logo geometry) that is NEVER described in captions — the model absorbs it into the trigger | brand-service, caption-service |
| **UNLOCKED Attribute** | A variable visual attribute (clothing, scene) that is ALWAYS described in captions — controllable by prompt at inference | brand-service, caption-service |
| **Caption** | A `.txt` file paired with each training image. Contains natural prose description of UNLOCKED attributes only | caption-service |
| **Rank** | Intrinsic dimension of LoRA matrices (r). Determines expressive capacity. Typical: 16 (simple), 32 (baseline), 64 (complex) | config-service |
| **Alpha** | Learning rate modulator. Formula: `contribution = (alpha / rank) × LR`. Typically alpha = rank | config-service |
| **Steps** | Total training iterations. Formula: `N_images × 40`. Range: 1000–5000 | config-service, training-service |
| **Loss** | Metric measuring how far the model is from predicting the correct transformation. Ideal final range: 0.20–0.40 | training-service |
| **Checkpoint** | Intermediate snapshot of weights during training. Saved every N steps. The best checkpoint is not always the last one | training-service |
| **Locked Attributes Card (LAC)** | JSON document listing all attributes PROHIBITED in captions for a specific subject | config-service, caption-service |
| **Resize Lanczos** | Image resizing algorithm that preserves fine details (edges, textures) better than bilinear/bicubic. Target: 1024×1024 | ingest-service |
| **LOCKED Violation** | When a LOCKED attribute appears in a caption — critical error that must be fixed before training | caption-service |
| **Stress Test** | Set of images generated with the trained model using varied prompts to validate quality | evaluation-service |
| **Multi-LoRA** | Simultaneous use of multiple LoRAs at inference (e.g., persona + style + color + logo), each with independent strength (0.0–1.0) | deploy-service |
| **Vision LLM** | Multimodal language model that receives an image + instruction and generates text description. Used for auto-captioning | caption-service |
| **Flow Matching** | The training paradigm used by Flux.1 Dev — learns a direct transformation from noise to image (vs. traditional diffusion's gradual denoising) | paper/02-METHODOLOGY |
| **Concept Bleeding** | Destructive fusion where incompatible visual topologies contaminate each other during training (e.g., 2D flat + 3D extruded) | paper/02-METHODOLOGY |
| **CUDA** | NVIDIA's parallel computing platform and API for GPU-accelerated computation | training-service |
| **TensorRT** | NVIDIA's inference optimization toolkit that accelerates model serving | deploy-service |
| **NIM** | NVIDIA Inference Microservices — optimized containers for deploying AI models | paper/05-RELATED-WORK |
| **NGC** | NVIDIA GPU Cloud — catalog of pre-optimized model containers | paper/05-RELATED-WORK |
| **NVIDIA Inception** | NVIDIA's startup acceleration program that validates and supports AI pipelines on NVIDIA hardware | paper/05-RELATED-WORK |
| **Triton** | NVIDIA Triton Inference Server — multi-framework model serving platform | paper/05-RELATED-WORK |
| **Inferentia** | AWS custom ML inference chip (alternative to NVIDIA GPUs for inference workloads) | paper/03-ARCHITECTURE |
| **TPU** | Google's Tensor Processing Unit (alternative to NVIDIA GPUs) | paper/03-ARCHITECTURE |

---

*← Back to [README](../README.md)*
