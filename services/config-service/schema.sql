-- config-service database schema
-- LoRA Registry — Single Source of Truth

CREATE TABLE lora_configs (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id            UUID NOT NULL,
    org_id                UUID NOT NULL,
    trigger_word          VARCHAR(9) NOT NULL,
    class_word            VARCHAR(50) NOT NULL,
    lora_type             VARCHAR(50) NOT NULL,
    meta_triggers         JSONB,
    locked_terms          JSONB NOT NULL,
    rank                  INT NOT NULL DEFAULT 32,
    alpha                 INT NOT NULL DEFAULT 32,
    steps                 INT NOT NULL DEFAULT 2000,
    learning_rate         FLOAT NOT NULL DEFAULT 0.0001,
    optimizer             VARCHAR(50) DEFAULT 'adamw8bit',
    noise_scheduler       VARCHAR(50) DEFAULT 'flowmatch',
    dtype                 VARCHAR(10) DEFAULT 'bf16',
    batch_size            INT DEFAULT 1,
    ema_enabled           BOOLEAN DEFAULT TRUE,
    ema_decay             FLOAT DEFAULT 0.99,
    train_text_encoder    BOOLEAN DEFAULT FALSE,
    caption_dropout_rate  FLOAT DEFAULT 0.05,
    inference_strength    FLOAT DEFAULT 0.85,
    guidance_scale        FLOAT DEFAULT 4.0,
    sample_steps          INT DEFAULT 20,
    t5_token_count        INT,
    clip_token_count      INT,
    tokenization_status   VARCHAR(20),
    version               INT DEFAULT 1,
    created_at            TIMESTAMPTZ DEFAULT NOW(),
    updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_trigger_org ON lora_configs(trigger_word, org_id);
