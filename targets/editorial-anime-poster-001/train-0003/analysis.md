# Review Analysis

## Observations

- All required workflow, analysis, judge, calibration, round, candidate, selection, and state artifacts are present and parse as JSON where applicable.
- The declared provenance contract was used exactly: each candidate's `generation.output.path` points to its repository-local `image.png`, and its `generation.output.sha256` matches a fresh SHA-256 calculation. The declared prompt and both declared input references also exist and their recorded hashes match fresh calculations.
- Candidate-004 is the deterministic round and global winner at total loss 0.0785 (reward 0.9215). The recomputed value is `0.14×0.30 + 0.02×0.10 + 0.04×0.15 + 0.02×0.15 + 0.10×0.25 + 0.01×0.05 = 0.0785`.
- Candidate-004's raw judge evidence records preservation of the source person's facial geometry, complexion, brows, eyes, nose, lips, jaw, cheek moles, ear, and left-facing pose. It also records a transferable editorial-anime poster treatment without substituting the style-reference woman's identity.
- The calibrated judge relations are all marked passed. The workflow stop is consistent with the run contract because 0.0785 is no greater than the 0.08 target in round 1, before the configured two-round maximum.

## Evaluation boundary

`train-0002` is a failed provenance record and used `judge-v2-style-identity`; its reported loss is not compared with this run's `judge-v3-style-identity-provenance` loss. No existing completed best candidate under judge v3 was present, so this verified completed result initializes `best.json` for that evaluator version.

## Remaining limitation

The selected image still has a fuller, more windblown crown than the compact source quiff, with somewhat uniform hair and garment linework. This is an evidence-backed refinement opportunity, not a reason to continue this run after its target-loss exit.
