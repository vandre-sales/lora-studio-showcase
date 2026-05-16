-- caption-service database schema

CREATE TABLE captioning_jobs (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dataset_id        UUID NOT NULL,
    lora_config_id    UUID NOT NULL,
    status            VARCHAR(50) DEFAULT 'PENDING',
    captions_generated INT DEFAULT 0,
    violations_found  INT DEFAULT 0,
    created_at        TIMESTAMPTZ DEFAULT NOW(),
    completed_at      TIMESTAMPTZ
);

CREATE TABLE captions (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id          UUID NOT NULL REFERENCES captioning_jobs(id),
    dataset_id      UUID NOT NULL,
    image_id        UUID NOT NULL,
    text            TEXT NOT NULL,
    token_count     INT,
    violations      JSONB DEFAULT '[]',
    edited_by       UUID,
    version         INT DEFAULT 1,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);
