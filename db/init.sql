CREATE TABLE IF NOT EXISTS regression_runs (
 id UUID PRIMARY KEY, created_at TIMESTAMPTZ DEFAULT now(), baseline_name TEXT NOT NULL, candidate_name TEXT NOT NULL,
 status TEXT NOT NULL, cases_total INT NOT NULL, cases_regressed INT NOT NULL DEFAULT 0, summary JSONB NOT NULL DEFAULT '{}'::jsonb
);
CREATE TABLE IF NOT EXISTS case_results (
 id UUID PRIMARY KEY, run_id UUID REFERENCES regression_runs(id) ON DELETE CASCADE, case_id TEXT NOT NULL, input JSONB NOT NULL,
 baseline JSONB NOT NULL, candidate JSONB NOT NULL, metrics JSONB NOT NULL, verdict TEXT NOT NULL, reasons JSONB NOT NULL DEFAULT '[]'::jsonb
);
