-- training-service database schema

CREATE TABLE training_jobs (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id            UUID NOT NULL,
    package_id            UUID NOT NULL,
    lora_config_id        UUID NOT NULL,
    provider              VARCHAR(50) NOT NULL,
    provider_job_id       VARCHAR(255),
    status                VARCHAR(50) DEFAULT 'QUEUED',
    current_step          INT DEFAULT 0,
    total_steps           INT NOT NULL,
    loss_current          FLOAT,
    loss_final            FLOAT,
    safetensors_file_id   UUID,
    selected_checkpoint_id UUID,
    started_at            TIMESTAMPTZ,
    completed_at          TIMESTAMPTZ,
    created_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE checkpoints (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    training_job_id   UUID NOT NULL REFERENCES training_jobs(id),
    step              INT NOT NULL,
    loss              FLOAT NOT NULL,
    sample_file_ids   JSONB,
    safetensors_file_id UUID,
    is_selected       BOOLEAN DEFAULT FALSE,
    created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE loss_datapoints (
    id                BIGSERIAL PRIMARY KEY,
    training_job_id   UUID NOT NULL REFERENCES training_jobs(id),
    step              INT NOT NULL,
    loss              FLOAT NOT NULL,
    recorded_at       TIMESTAMPTZ DEFAULT NOW()
);
