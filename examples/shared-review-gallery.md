# Shared Review Gallery — Visual Approval Flow

This document describes the review experience shared by Creator and Data Scientist — the mandatory Gate 3.

## Gallery View (Creator Perspective)
**Header:** "Model 'Brand X' is ready for review!"
- Progress bar: 0/6 images voted

**Image grid:** 6 stress test images displayed in 2×3 grid

**Per-image interaction:**
- Click to fullscreen with zoom
- Buttons: APPROVE (green) | REJECT (red)
- If REJECT: comment field + visual pin on image
  - "Click the point on the image that needs adjustment"
  - Pin appears with comment balloon (e.g., pin on blurry logo)

**Comparison view:**
- Before/after slider
- Left: Original brand reference photo
- Right: AI-generated image from the model

**Finalization:**
- Summary: "5 approved, 1 rejected"
- Buttons: "Approve for Production" or "Request Adjustments"
- Actions: `POST /review-cycles/{id}/vote` → `POST /review-cycles/{id}/finalize`

## Gallery View (DS Perspective — Same Screen, Extra Data)
Same image grid with **technical overlay:**
- CLIP similarity score per image (e.g., 0.92)
- Trigger activation status: YES/NO
- LOCKED fidelity score (e.g., 0.87)
- Prompt used to generate each image

**Feedback tasks panel:**
- Creator's feedback auto-translated to technical tasks
- Example: "Logo is blurry" → Suggestion: "Increase rank 32→64"
- DS can: Accept & re-train | Ignore

## Re-Training Loop (If Rejected)

```
Creator rejects → Feedback recorded → review-service translates to tasks →
DS receives technical tasks → Adjusts captions/hyperparams → Re-trains →
New evaluation → New review cycle → Creator reviews again
```

The loop continues until Creator explicitly approves (Gate 3 is NEVER skipped).

---

**Key UX principle:** Creator sees visual results only. DS sees visual + technical data. Same URL, different rendering based on role (RBAC).

*← Back to [README](../README.md)*
