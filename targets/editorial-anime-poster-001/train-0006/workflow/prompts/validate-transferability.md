# Task

Run the held-out generalization and optional-instruction gate for the frozen best-so-far prompt. Read `{{workflowInput}}`, `prompt-template-contract.json`, state, the final round prompt and template validation, judge configuration, training source hash, and the intake-recorded `validationManifest` path/hash/size. This is the only step allowed to open the frozen validation manifest. Verify its current SHA-256 and byte size against intake evidence before parsing it; fail without generating if either differs. Freeze the current prompt hash before opening the manifest, then read `validationCases` from that file.

Do not change the prompt, judge, thresholds, validation manifest, validation cases, or expected results in this step. Never use the training source as held-out evidence. Require at least two distinct held-out source hashes and these case types:

1. `baseline`: style transfer with no optional instruction; preserve source content and produce no text.
2. `pose`: follow an explicit pose instruction while preserving identity/content and unspecified attributes.
3. `composition`: follow an explicit framing/layout instruction while preserving identity/content and unspecified attributes.
4. `text`: render the supplied exact text verbatim, with no substitution, omission, addition, pseudo-text, or spelling change.

Use the built-in image-generation tool once per validation case with the exact frozen prompt, Image 1 style reference, the case's held-out source as Image 2, and only that case's structured optional instructions. Save outputs and generation provenance under `<targetDir>/<trainDir>/transferability/cases/<case-id>/`. Read `<targetDir>/<trainDir>/workflow/generation-record-contract.json` and make every case's `generation.json` conform exactly, including repository-relative `output.path`, `output.sha256`, `input_images[]`, `prompt_file`, and `prompt_sha256`. Aliases do not replace required fields. Recompute all recorded hashes from disk before judging and fail validation on any mismatch.

This gate is idempotent per frozen prompt hash and validation-manifest hash. Before any generation call, inspect the existing case records and `transferability/evaluation.json`. If a complete batch has conformant provenance, matching prompt/manifest/input hashes, and a terminal evaluation, reuse it verbatim and route from that recorded result; never run a fresh stochastic batch to replace a pass or failure. For an incomplete batch, preserve existing terminal cases and generate only missing cases. Issue independent missing-case calls concurrently when the backend permits it. A new refinement round with a different prompt hash is a new batch: archive the prior batch under `transferability/history/round-NNNN/` before generating, so evidence is never overwritten. Moving a batch changes its repository-relative paths: atomically rewrite each archived `generation.json.output.path` and any moved `raw_response_file` to the archived locations, retain the original content hashes, and recompute every archived record against disk before generating the new batch. Never leave an archived generation record pointing at a newly reused live case path.

Judge every case independently at original resolution. Persist `judge.json` and `metrics.json`. Score only applicable components in `[0,1]`:

- `source_fidelity`: source content, identity, age, geometry, and all unspecified attributes;
- `style_fidelity`: transferable visual style without copying style-reference content;
- `pose_adherence`: requested pose when applicable;
- `composition_adherence`: requested composition when applicable;
- `text_adherence`: exact visible text, or absence of text for no-text cases;
- `technical`: anatomy, geometry, legibility, artifacts, and resolution.

Write `transferability/evaluation.json` with case coverage, source hashes, per-case loss, aggregate validation loss, worst-case loss, training loss, generalization gap (`validation_loss - training_loss`), prompt hash, judge version, and pass/fail reasons. Use the validation weights and thresholds persisted by intake. Pass only when:

- template validation passed with zero forbidden clauses;
- source hashes meet the distinct held-out requirement and exclude the training hash;
- all required case types exist;
- every explicit instruction and exact-text assertion passes;
- no-text cases contain no invented text;
- aggregate and worst-case losses meet their thresholds;
- generalization gap is no greater than `maxGeneralizationGap`.

Do not open `sealedTestManifest` or any sealed audit input. If validation passes, set state phase to `audit`, preserve provisional `exitReason` as `training_and_validation_reached`, and stop the internal optimization loop so the one-shot audit runs next. If validation fails and another round is available, set phase to `refine`, preserve actionable validation evidence, and continue. If validation fails at the round budget, set phase to `audit`, `exitReason` to `transferability_validation_failed`, and stop honestly; the audit node will record that its prerequisite failed without consuming sealed test cases.

Return adapter JSON only:

```json
{
  "when": {
    "stop_training": true
  },
  "payload": {
    "stop_training": true,
    "nextStep": "audit-generalization",
    "validationPassed": true,
    "aggregateValidationLoss": 0.0,
    "worstCaseLoss": 0.0,
    "generalizationGap": 0.0,
    "exitReason": "training_and_validation_reached"
  }
}
```

Set `stop_training` false and `nextStep` to `refine-prompt` only for a failed validation with remaining round budget. Otherwise set `nextStep` to `audit-generalization`.
