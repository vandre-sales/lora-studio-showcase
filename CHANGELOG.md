# Changelog

## [1.0.0] - 2026-05-16

### Published
- **README.md** — Hero image, 8 badges, architecture overview, business impact, credentials
- **paper/** — 5 sections: Problem, Methodology (LOCKED/UNLOCKED + LaTeX), Architecture (15 microservices DDD), Evaluation (4 metrics), Related Work (NVIDIA + Brazilian ecosystem)
- **services/** — 5 core service blueprints: config-service (SSoT), caption-service, training-service, evaluation-service, review-service — each with README, OpenAPI 3.0 spec, and SQL schema
- **examples/** — 3 UX flows: Creator onboarding (8 screens), DS training monitor, shared review gallery
- **GLOSSARY.md** — 28 ML terms explained for non-ML developers
- **assets/** — 3 ACME Goods visual assets (EXIF-stripped, compressed)

### Architecture Highlights
- 15 microservices across 5 DDD bounded contexts
- LOCKED/UNLOCKED protocol with mathematical derivation from Flow Matching loss function
- 3 Human-in-the-Loop gates in the pipeline (Caption Review, Hyperparameter Override, Visual Approval)
- Cloud-agnostic design: AWS canonical + GCP/Azure equivalents mapped
- NVIDIA ecosystem integration: H100/A100, NIM, NGC, Inception program
