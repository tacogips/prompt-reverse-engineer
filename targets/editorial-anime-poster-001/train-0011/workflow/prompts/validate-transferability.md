# Task

Run the held-out generalization and optional-instruction gate for the frozen best-so-far prompt. Read `{{workflowInput}}`, `prompt-template-contract.json`, state, the final round prompt and template validation, judge configuration, training source hash, and the intake-recorded `validationManifest` path/hash/size. This is the only step allowed to open the frozen validation manifest. Verify its current SHA-256 and byte size against intake evidence before parsing it; fail without generating if either differs. Freeze the current prompt hash before opening the manifest, then read `validationCases` from that file.

Do not change the prompt, judge, thresholds, validation manifest, validation cases, or expected results in this step. Never use the training source as held-out evidence. Require at least two distinct held-out source hashes and these case types:

1. `baseline`: style transfer with no optional instruction; preserve source content and produce no text.
2. `pose`: follow an explicit pose instruction while preserving identity/content and unspecified attributes.
3. `composition`: follow an explicit framing/layout instruction while preserving identity/content and unspecified attributes.
4. `text`: render the supplied exact text verbatim, with no substitution, omission, addition, pseudo-text, or spelling change.

Use the built-in image-generation tool once per validation case with the case's held-out source as Image 1 and the only image input. The target/style truth is judge-only: never pass it to generation. For each case, preserve the frozen base-prompt file and hash. Canonicalize only the case's structured optional instructions with `jq -cS` plus a final newline and hash those exact bytes. If the object is empty, use the base prompt itself as the effective prompt. Otherwise create `<case-dir>/effective-prompt.md` as the exact frozen base-prompt bytes followed by two newlines, `# Authorized Optional Instructions`, one newline, the canonical JSON, and a final newline. Send the effective-prompt file's bytes to the tool verbatim; never summarize, normalize, paraphrase, or re-render the base policy. Save outputs and provenance under `<targetDir>/<trainDir>/transferability/cases/<case-id>/`. Each `generation.json` must conform to the repository contract, record both base and effective prompt paths/hashes plus the optional-instruction hash, contain exactly one `input_images` entry with role `source_reference`, and contain neither a truth/style path nor its hash. Recompute every recorded hash before judging and fail on any mismatch.

This gate is idempotent per frozen prompt hash and validation-manifest hash. Before any generation call, inspect the existing case records and `transferability/evaluation.json`. If a complete batch has conformant provenance, matching prompt/manifest/input hashes, and a terminal evaluation, reuse it verbatim and route from that recorded result; never run a fresh stochastic batch to replace a pass or failure. For an incomplete batch, preserve existing terminal cases and generate only missing cases. Issue independent missing-case calls concurrently when the backend permits it. A new refinement round with a different prompt hash is a new batch: archive the prior batch under `transferability/history/round-NNNN/` before generating, so evidence is never overwritten. Moving a batch changes its repository-relative paths: atomically rewrite each archived `generation.json.output.path` and any moved `raw_response_file` to the archived locations, retain the original content hashes, and recompute every archived record against disk before generating the new batch. Never leave an archived generation record pointing at a newly reused live case path.

Judge every case independently at original resolution. Persist `judge.json` and `metrics.json`. This is a transfer gate, not teacher-image reconstruction. Score only applicable components in `[0,1]`:

- `source_fidelity`: source content, identity, age, geometry, and all unspecified attributes;
- `style_fidelity`: aggregate correspondence of medium/rendering, palette/tone, line/shape, texture/material, and graphic language without copying style-reference content;
- `pose_adherence`: requested pose when applicable;
- `composition_adherence`: requested composition when applicable;
- `text_adherence`: exact visible text, or absence of text for no-text cases;
- `technical`: anatomy, geometry, legibility, artifacts, and resolution.

Also persist the five style sub-losses for diagnosis. For applicable person sources, persist separate source-relative skin, hair, and clothing treatment losses. For exact-text cases, persist `typography_dialogue` style loss separately from spelling/adherence. Fail style transfer if the aggregate passes only because source or instruction adherence is strong while a required style dimension or feedback check exceeds its ceiling. Never compare the case to the teacher's subject, literal traits, pose, crop, concrete layout, wording, or scene.

Before persisting each case total, recompute it from the recorded components using exactly `0.20*medium_rendering + 0.15*palette_tone + 0.15*line_shape + 0.10*texture_material + 0.10*graphic_language + 0.20*source_fidelity + 0.10*technical`. Use full-precision component values, then round only the final displayed total. Instruction-adherence diagnostics and `typography_dialogue` are gates and diagnostics, not extra weighted terms. If a judge-proposed total differs from this recomputation beyond `1e-6`, replace it with the recomputed value and record the correction before writing metrics.

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
