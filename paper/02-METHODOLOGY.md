# 2. Methodology: The LOCKED/UNLOCKED Protocol

## 2.1. The Core Insight — Brand Memory Through Omission

The loss function in Flow Matching models (used by Flux.1 Dev and similar architectures):

$$L = \|v - v_\theta(x_t, t, c_{text})\|^2$$

Where:
- $v$ = target velocity field (ground truth direction from noise to image)
- $v_\theta$ = model's predicted velocity, conditioned on timestep $t$ and text embedding $c_{text}$
- $x_t$ = noisy image at timestep $t$

This equation has a profound architectural implication for brand identity:

**When a visual attribute is PRESENT in the training image but ABSENT from the caption**, the model has no text-conditioned path to reconstruct it. The only way to minimize the loss is to encode that attribute directly into the LoRA's weight adjustments — permanently bound to the trigger word.

This is **Brand Memory**: the deterministic encoding of visual identity into learned weights, not text prompts.

## 2.2. The LOCKED/UNLOCKED Classification

Every visual attribute in a training dataset must be classified into exactly one of two categories:

| Classification | Rule | Effect on Model | Inference Behavior |
|---|---|---|---|
| **LOCKED** | NEVER described in captions | Encoded in LoRA weights via trigger | Always present when trigger is used — unconditional |
| **UNLOCKED** | ALWAYS described in captions | Learned as text-conditioned | Controllable by prompt — flexible |

**Examples for a brand identity LoRA:**

| Attribute | Classification | Reasoning |
|---|---|---|
| Logo geometry (curves, proportions) | LOCKED | Permanent — must appear identically every time |
| Brand colors (exact hex values) | LOCKED | Non-negotiable visual identity |
| Typography (font, weight, spacing) | LOCKED | Core brand element |
| Background/scene | UNLOCKED | Varies by context |
| Lighting conditions | UNLOCKED | Varies by environment |
| Camera angle/composition | UNLOCKED | Creative decision per asset |
| Product in frame | UNLOCKED | Changes per campaign |

**This is not a heuristic. It is a deterministic effect of the mathematics.** If you describe your logo in the caption, you lose control — the model treats it as text-conditioned and reproduces it inconsistently. If you omit it, the loss function forces the model to memorize it.

## 2.3. Concept Bleeding — The Failure Mode

When the LOCKED/UNLOCKED separation is violated, the model produces **Concept Bleeding** — a destructive fusion where incompatible visual topologies contaminate each other.

**Example:** A brand logo exists in both 2D flat and 3D extruded formats. If both topologies are trained without proper separation, the model produces hybrid outputs: flat logos with phantom shadows, or 3D signs that look like stickers.

Prevention requires:
1. Consistent LOCKED/UNLOCKED annotation across the entire dataset
2. Separate training runs for topologically distinct substrates when necessary
3. Multi-LoRA composition at inference (one LoRA per topology)

## 2.4. Automated Captioning Pipeline

The dataset preparation pipeline automates LOCKED/UNLOCKED compliance:

1. **Vision LLM auto-captioning** with a brand-aware system prompt that injects locked terms as exclusion rules: *"Describe everything you see EXCEPT [locked_terms]"*
2. **Violation scanner** using word-boundary regex (`\b{term}\b`) — not substring matching. This prevents false positives: "red" inside "mirrored" or "art" inside "smart"
3. **Token budget validation** — each caption validated against T5 tokenizer (target: 50–200 tokens). Below 50: insufficient conditioning. Above 200: attention dilution
4. **Pre-training gate** — training service rejects dispatch if violations > 0. Contaminated datasets never reach the GPU

**Caption structure:**

```
{trigger} {class_word}. {expression}. {clothing + accessories}. {pose/action}. {scene + lighting + composition}.
```

All captions use natural prose (not comma-separated tags) because the T5-XXL encoder in Flux.1 processes semantic relationships in sentences — subject-verb-object relations produce more coherent embeddings than isolated tokens.

## 2.5. Hyperparameter Calculus by LoRA Type

Not all brand attributes have equal mathematical complexity:

| LoRA Type | Rank | Alpha | Steps Formula | Justification |
|---|---|---|---|---|
| **Persona** (face/body) | 32 | 32 | N_images × 40 | Moderate geometric complexity |
| **Identity** (logo/typography) | 64 | 32 | N_images × 50 | High-frequency spatial information |
| **Style** (architecture/environment) | 32 | 32 | N_images × 30 | Medium-frequency spatial patterns |
| **Color** (palette/proportions) | 16 | 16 | N_images × 20 | Low-frequency signal |

**Rank determines capacity:** Logos contain precise curves, exact proportions, and specific line weights — rank 16 would under-parameterize these features. Color palettes are low-frequency signals captured with fewer dimensions.

**EMA (Exponential Moving Average)** is mandatory for datasets with fewer than 100 images — prevents memorization of individual training samples rather than generalization of the brand attribute.

## 2.6. Multi-LoRA Composition at Inference

Multiple brand-specialized LoRAs compose simultaneously at inference:

| LoRA | Strength | Purpose |
|---|---|---|
| Persona | 0.85 | Dominant — defines who appears |
| Style | 0.70 | Environmental context |
| Logo | 0.65 | Brand mark placement |
| Color | 0.55 | Palette enforcement |

**The Sum Rule:** Total combined strength should not exceed 2.5. Beyond this threshold, LoRA weight modifications interfere destructively.

**Composition order matters:** Persona loads first (facial features need uncontaminated latent space). Logo loads last (high-frequency features are most resilient to prior modifications).

**Negative Control Validation:** Generate WITHOUT trigger word. If brand attribute still appears → LoRA has leaked into base weights → overtraining detected.

---

*Next: [03-ARCHITECTURE.md](03-ARCHITECTURE.md) — The 15-microservice system that orchestrates this pipeline.*
