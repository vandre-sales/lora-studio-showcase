-- review-service database schema

CREATE TABLE review_cycles (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    evaluation_id   UUID NOT NULL,
    project_id      UUID NOT NULL,
    status          VARCHAR(50) DEFAULT 'PENDING_REVIEW',
    decision        VARCHAR(50),
    approved_count  INT DEFAULT 0,
    rejected_count  INT DEFAULT 0,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    finalized_at    TIMESTAMPTZ
);

CREATE TABLE votes (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cycle_id    UUID NOT NULL REFERENCES review_cycles(id),
    image_id    UUID NOT NULL,
    voter_id    UUID NOT NULL,
    vote        VARCHAR(20) NOT NULL,
    comment     TEXT,
    pin_x       FLOAT,
    pin_y       FLOAT,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE feedback_tasks (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cycle_id                UUID NOT NULL REFERENCES review_cycles(id),
    feedback_text           TEXT NOT NULL,
    technical_suggestion    TEXT NOT NULL,
    severity                VARCHAR(20) NOT NULL,
    status                  VARCHAR(20) DEFAULT 'PENDING',
    assigned_to             UUID,
    created_at              TIMESTAMPTZ DEFAULT NOW()
);
