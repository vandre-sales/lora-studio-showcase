-- evaluation-service database schema

CREATE TABLE evaluations (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    training_job_id     UUID NOT NULL,
    status              VARCHAR(50) DEFAULT 'PENDING',
    trigger_activation  FLOAT,
    locked_fidelity     FLOAT,
    unlocked_diversity  FLOAT,
    negative_control    FLOAT,
    overall_score       FLOAT,
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    completed_at        TIMESTAMPTZ
);

CREATE TABLE eval_images (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    evaluation_id   UUID NOT NULL REFERENCES evaluations(id),
    prompt          TEXT NOT NULL,
    file_id         UUID NOT NULL,
    scores          JSONB,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
