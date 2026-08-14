# Verification result

Status: failed at 2026-08-14T03:43:22Z.

## Observations

- All four generated candidate PNGs are persisted under `rounds/round-0001/candidates/`, rather than only in a generation-tool cache. Each decoded successfully at 1023x1537 pixels, and every SHA-256 value matched its `generation.json` record.
- All six loss components for every candidate are within `[0, 1]`. Using the recorded judge weights, each stored total and reward recomputed exactly: candidate-001 `0.1105` / `0.8895`, candidate-002 `0.1195` / `0.8805`, candidate-003 `0.1280` / `0.8720`, and candidate-004 `0.1175` / `0.8825`.
- The recorded selection rule, `lowest_total_loss_then_candidate_id`, correctly selects candidate-001. This was the first and only round, so `global_best_after` cannot have replaced an earlier better candidate.
- The workflow exit condition is internally consistent: `0.1105 <= 0.15`, so `target_loss_reached` at round 1 is valid and does not conflict with the configured maximum of 3 rounds.
- All existing training JSON parsed successfully, and the persisted `prompt-reverse-train` workflow passed Riela validation.

## Blocking diagnostics

- `targets/editorial-anime-poster-001/target.json` is absent.
- `targets/editorial-anime-poster-001/truth/manifest.json` is absent.
- `judge/config.json` records `calibration_suite: null`, so the completed-iteration requirement for a calibration version is not satisfied.

## Consequence

The training result is numerically plausible but cannot be marked complete under the repository protocol. `best.json` was not created or updated, because only a completed result may become the target best.

## Next action

Add validated immutable target and truth manifests, and record a calibrated judge version before rerunning or reviewing the iteration for completion.
