# 4. Evaluation & Business Impact

## 4.1. Automated Quality Metrics

The evaluation-service generates stress test images and calculates four metrics before any human review:

| Metric | Threshold | What It Measures | How It's Calculated |
|---|---|---|---|
| **Trigger Activation** | > 0.80 | Does the trigger word reliably activate the brand attribute? | Generate with trigger → CLIP similarity vs reference image |
| **LOCKED Fidelity** | > 0.85 | Are non-negotiable elements accurately reproduced? | Generate WITHOUT describing LOCKED attrs → verify visual presence |
| **UNLOCKED Diversity** | > 0.70 | Can the model vary contextual elements? | Generate with different outfits/scenes → measure visual variation |
| **Negative Control** | < 0.20 | Does the attribute disappear without trigger? | Generate WITHOUT trigger → verify attribute absence |

These metrics are **indicative, not definitive**. A LoRA can pass all four thresholds and still produce output that a brand manager would reject — perhaps the logo is geometrically correct but the color temperature is wrong in context.

## 4.2. Stress Test Protocol

For each evaluation, the system auto-generates 6 test prompts:

1. `{trigger} {class}` — baseline (trigger only)
2. `{trigger} {class} in a sunny park` — outdoor scene
3. `{trigger} {class} in a studio with white background` — controlled environment
4. `{trigger} {class} wearing a red jacket` — specific clothing (persona type)
5. `A {class} in a park` — **negative control** (NO trigger)
6. `{trigger} {class} {campaign_brief_excerpt}` — real campaign context

## 4.3. Human Gates — The Non-Negotiable Layer

Automated metrics provide the first quality gate, but **human judgment remains the ultimate arbiter**:

| Gate | Who | When | Can Be Skipped? |
|---|---|---|---|
| **Caption Review** | Data Scientist | After auto-captioning | Yes (auto-proceed 24h) |
| **Hyperparameter Override** | Data Scientist | Before training dispatch | Yes (auto-proceed 1h) |
| **Visual Approval** | Creator / Creative Director | After evaluation scores | **NEVER** — mandatory |

The Visual Approval gate exists because brand perception includes subjective, cultural, and contextual factors that no automated metric captures. The creative director sees nuances in brand expression that CLIP similarity cannot measure.

## 4.4. Business Impact (Projected)

Based on enterprise brand production benchmarks:

| Metric | Traditional Process | With LoRA Studio | Improvement |
|---|---|---|---|
| **Campaign production time** | 6–8 weeks | 3–5 days | **85% reduction** |
| **Production cost per campaign** | $15K–40K | $2K–6K | **70% reduction** |
| **Brand compliance rate** | ~85% (human review) | 100% (mathematical enforcement) | **Structural guarantee** |
| **Design team focus** | 60–75% mechanical variations | 90%+ creative direction | **Liberation of creative capacity** |
| **Time to new substrate** | Weeks (new agency brief) | Hours (new LoRA training) | **Substrate agility** |

These are **projected outcomes** of architecting a system where brand enforcement is a structural property, not a process overhead. The actual metrics depend on dataset quality, brand complexity, and organizational adoption.

## 4.5. Loss Interpretation for Quality Assurance

The training-service monitors loss throughout the training process:

| Loss Range | Interpretation | Action |
|---|---|---|
| > 0.80 | Model hasn't learned (random) | Check config (LR, dataset) |
| 0.60–0.80 | Learning basic structure | Continue training |
| 0.40–0.60 | Learning intermediate features | Continue training |
| **0.20–0.40** | **Ideal range — fine features without overfitting** | **Select checkpoint here** |
| 0.15–0.20 | Borderline memorization | Stop or use earlier checkpoint |
| < 0.15 | Severe overfitting | Do NOT use this checkpoint |

---

*Next: [05-RELATED-WORK.md](05-RELATED-WORK.md) — Positioning within the global GenAI ecosystem.*
